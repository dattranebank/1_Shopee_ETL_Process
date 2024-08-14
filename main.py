# Thu thập dữ liệu tổng số tiền tất cả các đơn hàng đã đặt trên Shopee của Dat Tran Ebank
import pprint
import sys
from ETL import *
from analysis import *
from colorama import Fore, Style


def main():
    print("Nhập đường dẫn để input file, ví dụ như D:\\NewFolder\\Shopee_Orders.html")
    try:
        htmlfile = input("Input: ")
        # Kiểm tra xem tệp có phần mở rộng .html không
        if not htmlfile.lower().endswith('.html'):
            raise ValueError
        # Kiểm tra xem tệp có tồn tại không
        if os.path.exists(htmlfile):
            print(f"{Fore.GREEN}Tệp {htmlfile} đã được tìm thấy.{Style.RESET_ALL}")
        else:
            print(f"{Fore.RED}ERROR: Tệp không tồn tại.{Style.RESET_ALL}")
            sys.exit("Chương trình kết thúc do lỗi.")
    except ValueError:
        # Xử lý lỗi khi đường dẫn không hợp lệ (nếu áp dụng)
        print(f"{Fore.RED}ERROR: Đường dẫn không hợp lệ.{Style.RESET_ALL}")
        sys.exit("Chương trình kết thúc do lỗi.")

    print("Nhập đường dẫn để output file, ví dụ như D:\\Output")
    output_direc=input("Output: ")
    # Extract from HTML File
    orders_history_lst = extract_data_from_tag(htmlfile)
    # pprint.pprint(orders_history_lst)

    # Transform for T01_SELLERS
    lst_of_dicts_t01 = transform_data_for_t01(orders_history_lst)
    df1_unique = data_transformation_algorithm_for_t01(lst_of_dicts_t01)
    # Load to T01_SELLERS.csv
    load_to_csv_t01(df1_unique)

    # Transform for T02_ORDERS_HISTORY
    lst_of_dicts_t02 = transform_data_for_t02(orders_history_lst)
    df2 = transform_add_seller_id_for_t02(lst_of_dicts_t02, df1_unique)
    # Load to T02_ORDERS_HISTORY.csv
    load_to_csv_t02(df2)

    # Transform for T03_ORDER_DETAILS_HISTORY
    lst_of_dicts_t03 = transform_data_for_t03(orders_history_lst)
    # pprint.pprint(lst_of_dicts_t03)
    df3 = transform_for_t03(lst_of_dicts_t03)
    # Load to T03_ORDER_DETAILS_HISTORY.csv
    load_to_csv_t03(df3)


if __name__ == "__main__":
    main()
