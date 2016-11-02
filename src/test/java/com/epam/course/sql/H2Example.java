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
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class H2Example {
    private static DataSource ds;
    private static Flyway flyway;

    @BeforeClass
    public static void startUp() throws ClassNotFoundException {
        Class.forName("org.h2.Driver");
        JdbcDataSource ds = new JdbcDataSource();
        ds.setURL("jdbc:h2:mem:test_mem;DB_CLOSE_DELAY=-1");
        ds.setUser("sa");
        ds.setPassword("sa");
        H2Example.ds = ds;

        flyway = new Flyway();
        flyway.setDataSource(ds);
        flyway.setLocations("db/h2");
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
                                    "VALUES (test_schema.person_seq.nextval, 'TmpName', 'TmpLastName', 'TmpEmail', 55)"
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
