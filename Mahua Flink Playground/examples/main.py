from pyflink.table import StreamTableEnvironment, EnvironmentSettings
from pyflink.table import DataTypes

def simple_data_analysis():
    # Set up the streaming environment
    env_settings = EnvironmentSettings.new_instance().in_streaming_mode().build()
    t_env = StreamTableEnvironment.create(environment_settings=env_settings)

    # Define the source data
    source_data = [("Alice", 30), ("Bob", 20), ("Alice", 35), ("Bob", 25), ("Alice", 50)]

    # Create a table from the source data
    table = t_env.from_elements(source_data, DataTypes.ROW([DataTypes.FIELD("name", DataTypes.STRING()),
                                                           DataTypes.FIELD("age", DataTypes.INT())]))

    # Register a view for the source data
    t_env.create_temporary_view("source_table", table)

    # Filter and count the data
    filtered_count = t_env.sql_query(
        "SELECT name, COUNT(*) as count_age "
        "FROM source_table "
        "WHERE age > 30 "
        "GROUP BY name"
    )

    # Execute and print the result
    filtered_count.execute().print()

if __name__ == "__main__":
    simple_data_analysis()
