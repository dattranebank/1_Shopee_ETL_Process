import pprint
import pandas as pd


def data_transformation_algorithm_for_t01(lst_of_dicts):
    df1 = pd.DataFrame(lst_of_dicts)  # Chuyển lst of dicts sang dataframe
    # print(df)
    df1 = df1.drop(index=0)  # Loại bỏ giá trị NaN
    df1["SellerID"] = df1["SellerID"].astype(int)  # Chuyển SellerID từ float sang int

    # Đếm số lần xuất hiện của từng SellerName trong df
    # Điều này cho biết Dat Ebank đã mua sản phẩm của nhà bán hàng nào nhiều nhất
    # counts = df["SellerName"].value_counts()
    # print(counts)

    # Loại bỏ các giá trị SellerName bị trùng nhau, chỉ giữ lại giá trị mới nhất dựa vào SellerID
    # Đảm bảo mỗi SellerName chỉ xuất hiện một lần trong T01_SELLERS
    # df đã sắp xếp SellerID theo thứ tự tăng dần, có nghĩa là số 1 là mới nhất còn số 200 là cũ nhất
    df1_unique = df1.drop_duplicates(subset='SellerName', keep='first')

    # Reset index và loại bỏ index cũ, reset SellerID bắt đầu từ 1
    df1_unique = df1_unique.reset_index(drop=True)
    df1_unique.loc[:, "SellerID"] = range(1, len(df1_unique) + 1)
    return df1_unique


def transform_add_seller_id_for_t02(lst_of_dicts, df1):
    df2 = pd.DataFrame(lst_of_dicts)  # Chuyển lst for dicts sang dataframe
    df2 = df2.drop(index=0)  # Loại bỏ giá trị NaN
    df2["OrderID"] = df2["OrderID"].astype(int)  # Chuyển OrderID từ float sang int

    # Thực hiện phép nối để thêm SellerID vào df2 dựa trên SellerName ở df1 và df2
    df2 = pd.merge(df2, df1[["SellerID", "SellerName"]], on="SellerName", how="left")
    # Xóa cột SellerName trong df2
    df2 = df2.drop(columns="SellerName")
    # Thay đổi vị trí cột SellerID
    df2 = df2[["OrderID", "SellerID", "InvoiceAmount"]]
    return df2


def transform_for_t03(lst_of_dicts):
    df3 = pd.DataFrame(lst_of_dicts)
    df3 = df3.drop(index=0)  # Loại bỏ giá trị NaN
    df3["OrderDetailID"] = df3["OrderDetailID"].astype(int)  # Chuyển OrderDetailID từ float sang int
    df3["OrderID"] = df3["OrderID"].astype(int)  # Chuyển OrderID từ float sang int
    return df3
