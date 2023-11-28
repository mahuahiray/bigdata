from pyflink.table import StreamTableEnvironment, EnvironmentSettings
from pyflink.table import DataTypes

def sales_data_analysis():
    # Set up the streaming environment
    env_settings = EnvironmentSettings.new_instance().in_streaming_mode().build()
    t_env = StreamTableEnvironment.create(environment_settings=env_settings)

    # Define the source data: ProductID, UnitsSold
    sales_data = [("P001", 10), ("P002", 5), ("P001", 15), ("P003", 20), ("P002", 10)]

    # Define the schema of the table
    schema = DataTypes.ROW([
        DataTypes.FIELD("product_id", DataTypes.STRING()),
        DataTypes.FIELD("units_sold", DataTypes.INT())
    ])

    # Create a table from the source data
    table = t_env.from_elements(sales_data, schema)

    # Register a view for the sales data
    t_env.create_temporary_view("sales_table", table)

    # Calculate the total units sold per product
    total_sales = t_env.sql_query(
        "SELECT product_id, SUM(units_sold) as total_units "
        "FROM sales_table "
        "GROUP BY product_id"
    )

    # Execute and print the result
    total_sales.execute().print()

if __name__ == "__main__":
    sales_data_analysis()
