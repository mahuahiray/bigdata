from pyflink.table import TableEnvironment, EnvironmentSettings
from pyflink.table import DataTypes

def employee_data_analysis():
    # Set up the batch environment
    env_settings = EnvironmentSettings.new_instance().in_batch_mode().build()
    t_env = TableEnvironment.create(environment_settings=env_settings)

    # Define the source data: EmployeeID, Name, Age
    employee_data = [("E001", "John", 45), ("E002", "Sarah", 29),
                     ("E003", "Mike", 32), ("E004", "Emma", 42), ("E005", "Emily", 24)]

    # Define the schema of the table
    schema = DataTypes.ROW([
        DataTypes.FIELD("employee_id", DataTypes.STRING()),
        DataTypes.FIELD("name", DataTypes.STRING()),
        DataTypes.FIELD("age", DataTypes.INT())
    ])

    # Create a table from the source data
    table = t_env.from_elements(employee_data, schema)

    # Register a view for the employee data
    t_env.create_temporary_view("employee_table", table)

    # Filter employees older than 30 and sort them by age in descending order
    filtered_sorted_employees = t_env.sql_query(
        "SELECT employee_id, name, age "
        "FROM employee_table "
        "WHERE age > 30 "
        "ORDER BY age DESC"
    )

    # Execute and print the result
    filtered_sorted_employees.execute().print()

if __name__ == "__main__":
    employee_data_analysis()
