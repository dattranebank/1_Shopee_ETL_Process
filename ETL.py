import os.path
import pprint
from bs4 import BeautifulSoup
from colorama import Fore, Style


def read_html(file_name):
    with open(file_name, "r", encoding="utf-8") as file:
        html_file = file.read()
    soup = BeautifulSoup(html_file, features="lxml")  # Creating a BeautifulSoup object and specifying the parser
    return soup


def get_and_save_tag(parent_tag, tag_name, **kwargs):
    tag = parent_tag.find(tag_name, **kwargs)
    return tag


def extract_data_from_tag(htmlfile):
    soup = read_html(htmlfile)
    body_tag = get_and_save_tag(soup, "body")  # Get body tag trong soup
    main_div_tag = get_and_save_tag(body_tag, "div", id="main")  # Get main div tag trong body_tag
    div_fkii86_tag = get_and_save_tag(main_div_tag, "div", class_="fkIi86")  # Get div fkIi86 tag trong main div tag
    div_ashfmq_tag = get_and_save_tag(div_fkii86_tag, "div", class_="ashFMQ")  # Get div ashFMQ tag trong div fkIi86 tag
    orders_history_lst = div_ashfmq_tag.find_all("div", "YL_VlX")  # Database từng đơn hàng
    return orders_history_lst


def transform_data_for_t01(orders_history_lst):
    sellers_lst_of_dicts = [{}]  # List chứa các dictionary
    seller_id = 0  # SellerID
    for order_history in orders_history_lst:
        seller_id += 1  # SellerID
        seller_name = order_history.find("div", "UDaMW3").get_text()  # SellerName
        # SellerType, tại sao phải tạo 2 biến seller_type 1 và 2? Vì nó tồn tại 2 div "Koi0Pw" và "Es_V3Q xzDLS0"
        # mỗi div này chứa giá trị khác nhau và nó không tồn tại song song, nó chỉ tồn tại 1 trong 2 mà thôi
        # do đó ta phải kiểm tra nếu type_1 là None, type_2 not None thì lấy giá trị type_2 và ngược lại
        seller_type_1 = order_history.find("div", "Koi0Pw")  # Có giá trị Preferred Seller & Preferred Seller Plus
        seller_type_2 = order_history.find("div", "Es_V3Q xzDLS0")  # Có giá trị Mall

        # Tại sao không dùng get_text() cho seller_type_1 và 2 phía trên?
        # vì nếu không tồn tại div khi find mà lại dùng get_text() thì sẽ bị lỗi
        # do đó ta cần đảm bảo seller_type_1 và 2 not None thì mới dùng get_text được
        seller_type = ""
        if seller_type_1 is not None:
            seller_type = seller_type_1.get_text()
        elif seller_type_2 is not None:
            seller_type = "Mall"
        if not seller_type:
            seller_type = "Normal"
        sellers_lst_of_dicts.append({"SellerID": seller_id, "SellerName": seller_name, "SellerType": seller_type})
    return sellers_lst_of_dicts


def load_to_csv_t01(df, output_path):
    try:
        # Write .csv file
        output_path = output_path + "T01_SELLER.csv"
        df.to_csv(output_path, sep=",", encoding="utf-8", index=False, header=True)
        # Check if file was created successfully
        if os.path.exists("Output\\T01_SELLERS.csv"):
            print(f"{Fore.GREEN}T01_SELLERS.csv file has been successfully exported.{Style.RESET_ALL}")
        else:
            print(f"{Fore.RED}ERROR: T01_SELLERS.csv file was not created.{Style.RESET_ALL}")
    except Exception as e:
        print(f"{Fore.RED}ERROR: An error occurred while exporting T01_SELLERS.csv file: {e}{Style.RESET_ALL}")


def transform_data_for_t02(orders_history_lst):
    orders_lst_of_dicts = [{}]  # List chứa các dictionary
    # Ta cần cập nhật SellerID mới có thể liên kết với T01_SELLERS
    i = 0  # ID đơn hàng as OrderID
    for order_history in orders_history_lst:
        i += 1  # ID đơn hàng as Order ID
        seller_name = order_history.find("div", "UDaMW3").get_text()  # Tên nhà bán hàng as SellerName
        # Tổng số tiền thực tế as InvoiceAmount
        invoice_amount = order_history.find("div", "t7TQaf").get_text()
        invoice_amount = invoice_amount.replace("₫", "")  # Remove ₫ character
        invoice_amount = invoice_amount.replace(".", "")  # Remove . character
        # Tại sao lại remove "."? Vì nếu ta để "." thì nó sẽ hiểu là số thập phân
        orders_lst_of_dicts.append({"OrderID": i, "SellerName": seller_name, "InvoiceAmount": invoice_amount})
    return orders_lst_of_dicts


def load_to_csv_t02(df, output_path):
    try:
        # Write .csv file
        output_path = output_path + "T02_ORDERS_HISTORY.csv"
        df.to_csv(output_path, sep=",", encoding="utf-8", index=False, header=True)
        # Check if file was created successfully
        if os.path.exists("Output\\T02_ORDERS_HISTORY.csv"):
            print(f"{Fore.GREEN}T02_ORDERS_HISTORY.csv file has been successfully exported.{Style.RESET_ALL}")
        else:
            print(f"{Fore.RED}ERROR: T02_ORDERS_HISTORY.csv file was not created.{Style.RESET_ALL}")

    except Exception as e:
        print(f"{Fore.RED}ERROR: An error occurred while exporting T02_ORDERS_HISTORY.csv file: {e}{Style.RESET_ALL}")


def transform_data_for_t03(orders_history_lst):
    orders_lst_of_dicts = [{}]  # List chứa các dictionary
    order_detail_id = 1
    order_id = 1
    for order_history in orders_history_lst:
        products_history_lst = order_history.div("div", "nmdHRf")
        for product_history in products_history_lst:
            product_name = product_history.find("span", "DWVWOJ").get_text()
            product_type = None
            product_type_element = product_history.find("div", "rsautk")
            product_quantity = product_history.find("div", "j3I_Nh").get_text().replace("x", "")
            if product_type_element is not None:
                product_type = product_type_element.get_text().replace("Phân loại hàng: ", "")
            else:
                product_type = None
            orders_lst_of_dicts.append({"OrderDetailID": order_detail_id, "OrderID": order_id,
                                        "ProductName": product_name, "ProductType": product_type,
                                        "Quantity": product_quantity})
            order_detail_id += 1
        order_id += 1
    return orders_lst_of_dicts


def load_to_csv_t03(df,output_path):
    try:
        # Write .csv file
        output_path = output_path + "T03_ORDER_DETAILS.csv"
        df.to_csv(output_path, sep=",", encoding="utf-8", index=False, header=True)
        # Check if file was created successfully
        if os.path.exists("Output\\T03_ORDER_DETAILS_HISTORY.csv"):
            print(f"{Fore.GREEN}T03_ORDER_DETAILS_HISTORY.csv file has been successfully exported.{Style.RESET_ALL}")
        else:
            print(f"{Fore.RED}ERROR: T03_ORDER_DETAILS_HISTORY.csv file was not created.{Style.RESET_ALL}")
    except Exception as e:
        print(
            f"{Fore.RED}ERROR: An error occurred while exporting T03_ORDER_DETAILS_HISTORY.csv file: {e}{Style.RESET_ALL}")
