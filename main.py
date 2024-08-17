# Thu thập dữ liệu tổng số tiền tất cả các đơn hàng đã đặt trên Shopee của Dat Tran Ebank
from datetime import datetime
import logging
import pprint
import sys
from ETL import *
from analysis import *
from colorama import Fore, Style

# Tạo tên file log với dấu thời gian
log_filename = f"log_files/shopee_orders_{datetime.now().strftime('%Y%m%d_%H%M%S')}.log"

# Cấu hình logging
logging.basicConfig(filename=log_filename, level=logging.INFO,
                    format="%(asctime)s - %(levelname)s - %(message)s",
                    encoding="utf-8")


def main():
    logging.info("Chương trình bắt đầu.")
    print(f"{Fore.BLUE}Nhập đường dẫn để import file, ví dụ như H:\\Input\\Shopee_Orders.html{Style.RESET_ALL}")

    # Input
    try:
        htmlfile = input(f"Input path: ")
        # Kiểm tra xem tệp có phần mở rộng .html không
        if not htmlfile.lower().endswith('.html'):
            raise ValueError
        # Kiểm tra xem tệp có tồn tại không
        if os.path.exists(htmlfile):
            logging.info(f"Tệp {htmlfile} đã được tìm thấy.")
            print(f"{Fore.GREEN}Tệp {htmlfile} đã được tìm thấy.{Style.RESET_ALL}")
        else:
            logging.error(f"Tệp {htmlfile} không tồn tại.")
            logging.error("Chương trình kết thúc do lỗi.")
            print(f"{Fore.RED}ERROR: Tệp không tồn tại.{Style.RESET_ALL}")
            sys.exit(f"{Fore.RED}Chương trình kết thúc do lỗi.{Style.RESET_ALL}")
    except ValueError:
        # Xử lý lỗi khi đường dẫn không hợp lệ
        logging.error("Đường dẫn không hợp lệ.")
        logging.error("Chương trình kết thúc do lỗi.")
        print(f"{Fore.RED}ERROR: Đường dẫn không hợp lệ.{Style.RESET_ALL}")
        sys.exit(f"{Fore.RED}Chương trình kết thúc do lỗi.{Style.RESET_ALL}")

    logging.info("Bắt đầu xử lý dữ liệu.")
    print()
    print(f"{Fore.BLUE}Nhập đường dẫn để export .csv file, ví dụ như H:\\Output_csv{Style.RESET_ALL}")
    output_path = input("Output path: ")

    # Kiểm tra xem thư mục đã tồn tại chưa, nếu chưa thì tạo mới
    if not os.path.exists(output_path):
        try:
            os.makedirs(output_path)
            logging.info(f"Thư mục {output_path} đã được tạo thành công.")
            print(f"{Fore.GREEN}Thư mục {output_path} đã được tạo thành công.{Style.RESET_ALL}")
        except Exception as e:
            logging.error(f"Không thể tạo thư mục {output_path}.")
            logging.error("Chương trình kết thúc do lỗi.")
            print(f"{Fore.RED}Không thể tạo thư mục {output_path}: {e}{Style.RESET_ALL}")
            sys.exit(f"{Fore.RED}Chương trình kết thúc do lỗi.{Style.RESET_ALL}")
    else:
        logging.info(f"Thư mục {output_path} đã tồn tại.")
        print(f"{Fore.GREEN}Thư mục đã tồn tại.{Style.RESET_ALL}")

    # Extract
    try:
        # Extract from HTML File
        orders_history_lst = extract_data_from_tag(htmlfile)
        logging.info("Dữ liệu đã được extract từ file HTML.")
    except Exception as e:
        logging.error(f"Đã xảy ra lỗi: {str(e)}")
        logging.error("Chương trình kết thúc do lỗi.")
        print(f"{Fore.RED}ERROR: Đã xảy ra lỗi trong quá trình extract.{Style.RESET_ALL}")
        print(f"{Fore.RED}Đã xảy ra lỗi: {str(e)}{Style.RESET_ALL}")
        sys.exit("Chương trình kết thúc do lỗi.")

    # Transform
    try:
        # Transform for T01_SELLERS
        lst_of_dicts_t01 = transform_data_for_t01(orders_history_lst)
        df1_unique = data_transformation_algorithm_for_t01(lst_of_dicts_t01)
        logging.info("Dữ liệu đã được transform cho T01_SELLERS.")

        # Transform for T02_ORDERS_HISTORY
        lst_of_dicts_t02 = transform_data_for_t02(orders_history_lst)
        df2 = transform_add_seller_id_for_t02(lst_of_dicts_t02, df1_unique)
        logging.info("Dữ liệu đã được transform cho T02_ORDERS_HISTORY.")

        # Transform for T03_ORDER_DETAILS_HISTORY
        lst_of_dicts_t03 = transform_data_for_t03(orders_history_lst)
        df3 = transform_for_t03(lst_of_dicts_t03)
        logging.info("Dữ liệu đã được transform cho T03_ORDER_DETAILS_HISTORY.")
    except Exception as e:
        logging.error(f"Đã xảy ra lỗi: {str(e)}")
        logging.error("Chương trình kết thúc do lỗi.")
        print(f"{Fore.RED}ERROR: Đã xảy ra lỗi trong quá trình transform.{Style.RESET_ALL}")
        print(f"Đã xảy ra lỗi: {str(e)}")
        sys.exit("Chương trình kết thúc do lỗi.")

    # Load
    try:
        # Load to T01_SELLERS.csv
        load_to_csv_t01(df1_unique, output_path)
        logging.info("Dữ liệu đã được load vào T01_SELLERS.csv.")

        # Load to T02_ORDERS_HISTORY.csv
        load_to_csv_t02(df2, output_path)
        logging.info("Dữ liệu đã được load vào T02_ORDERS_HISTORY.csv.")

        # Load to T03_ORDER_DETAILS_HISTORY.csv
        load_to_csv_t03(df3, output_path)
        logging.info("Dữ liệu đã được load vào T03_ORDER_DETAILS_HISTORY.csv.")
    except Exception as e:
        logging.error(f"Đã xảy ra lỗi: {str(e)}")
        logging.error("Chương trình kết thúc do lỗi.")
        print(f"{Fore.RED}ERROR: Đã xảy ra lỗi trong quá trình load.{Style.RESET_ALL}")
        print(f"Đã xảy ra lỗi: {str(e)}")
        sys.exit("Chương trình kết thúc do lỗi.")


    logging.info("Chương trình kết thúc.")

if __name__ == "__main__":
    main()
