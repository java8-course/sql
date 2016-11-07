package com.epam.course.sql;

import lombok.Builder;
import lombok.Data;
import org.flywaydb.core.Flyway;
import org.h2.jdbcx.JdbcDataSource;
import org.junit.After;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;

import javax.sql.DataSource;
import java.sql.*;

public class H2Example {
    private static DataSource ds;
    private static Flyway flyway;

    @BeforeClass
    public static void startUp() throws ClassNotFoundException, SQLException {
        final String url = "jdbc:h2:mem:test_mem;DB_CLOSE_DELAY=-1;MODE=PostgreSQL";
        final String username = "sa";
        final String password = "sa";

        Class.forName("org.h2.Driver");

        try (Connection connection = DriverManager.getConnection(url, username, password)) {
            final PreparedStatement statement = connection.prepareStatement("CREATE SCHEMA test_schema;");
            statement.execute();
        }

        JdbcDataSource ds = new JdbcDataSource();
        ds.setURL(url + ";SCHEMA=test_schema");
        ds.setUser(username);
        ds.setPassword(password);
        H2Example.ds = ds;

        flyway = new Flyway();
        flyway.setDataSource(ds);
        flyway.setLocations("db/postgresql");
    }

    @Before
    public void before() {
        flyway.migrate();
    }

    @After
    public void after() {
        flyway.clean();
    }

    @Data
    @Builder
    private static class Person {
        private final long id;
        private final String firstName;
        private final String lastName;
        private final String email;
        private final int age;
    }

    @Test
    public void selectFromPerson() throws SQLException {
        try (Connection connection = ds.getConnection()) {
            final PreparedStatement selectPersons =
                    connection.prepareStatement(
                            "SELECT p.person_id, p.first_name, p.last_name, p.email, p.age" +
                                    " FROM test_schema.person p" +
                                    " WHERE p.age > ?"
                    );

            System.out.println("Before insert");

            selectPersons.setInt(1, 35);

            printPersons(selectPersons.executeQuery());

            final PreparedStatement insert =
                    connection.prepareStatement(
                            "INSERT INTO test_schema.person(person_id, first_name, last_name, email, age)" +
                                    "VALUES (nextval('test_schema.person_seq'), 'TmpName', 'TmpLastName', 'TmpEmail', 55)"
//                                    "VALUES (test_schema.person_seq.nextval, 'TmpName', 'TmpLastName', 'TmpEmail', 55)"
                    );

            System.out.println("Inserted: " + insert.executeUpdate());

            selectPersons.setInt(1, 35);

            printPersons(selectPersons.executeQuery());
        }
    }

    private void printPersons(ResultSet resultSet) throws SQLException {
        while (resultSet.next()) {
            final Person person = Person.builder()
                    .id(resultSet.getLong("person_id"))
                    .firstName(resultSet.getString("first_name"))
                    .lastName(resultSet.getString("last_name"))
                    .email(resultSet.getString("email"))
                    .age(resultSet.getInt("age"))
                    .build();

            System.out.println(person);
        }
    }

    @Test
    public void selectFromPerson2() throws SQLException {
        try (Connection connection = ds.getConnection()) {
            final PreparedStatement statement =
                    connection.prepareStatement(
                            "SELECT p.person_id, p.first_name, p.last_name, p.email, p.age" +
                                    " FROM test_schema.person p" +
                                    " WHERE p.age > ?"
                    );

            statement.setInt(1, 35);

            final ResultSet resultSet = statement.executeQuery();

            printPersons(resultSet);
        }
    }
}
