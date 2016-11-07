package com.epam.course.sql;

import lombok.Builder;
import lombok.Data;
import org.flywaydb.core.Flyway;
import org.junit.*;
import org.postgresql.ds.PGPoolingDataSource;
import ru.yandex.qatools.embed.postgresql.PostgresExecutable;
import ru.yandex.qatools.embed.postgresql.PostgresProcess;
import ru.yandex.qatools.embed.postgresql.PostgresStarter;
import ru.yandex.qatools.embed.postgresql.config.PostgresConfig;

import javax.sql.DataSource;
import java.io.IOException;
import java.sql.*;

public class PostgresqlExample {
    private static DataSource ds;
    private static Flyway flyway = new Flyway();
    private static PostgresProcess process;

    @BeforeClass
    public static void startUp() throws IOException, ClassNotFoundException, SQLException {
        final String name = "yourDbname";
        final String username = "yourUser";
        final String password = "yourPassword";

        Class.forName("org.postgresql.Driver");

        final PostgresStarter<PostgresExecutable, PostgresProcess> runtime = PostgresStarter.getDefaultInstance();
        final PostgresConfig config = PostgresConfig.defaultWithDbName(name, username, password);

        final PostgresExecutable executable = runtime.prepare(config);
        process = executable.start();

        final String url = String.format("jdbc:postgresql://%s:%s/%s",
                config.net().host(),
                config.net().port(),
                config.storage().dbName()
        );

        try (Connection connection = DriverManager.getConnection(url, username, password)) {
            final PreparedStatement statement = connection.prepareStatement(
                    "CREATE SCHEMA test_schema;" +
                            " ALTER USER \"" + username + "\" SET search_path TO test_schema;");
            statement.execute();
        }

        PGPoolingDataSource ds = new PGPoolingDataSource();
        ds.setDatabaseName(config.storage().dbName());
        ds.setPortNumber(config.net().port());
        ds.setServerName(config.net().host());
        ds.setUser(username);
        ds.setPassword(password);
        PostgresqlExample.ds = ds;

        flyway.setLocations("db/postgresql");
        flyway.setDataSource(ds);
//        flyway.setDataSource(url, username, password);
    }

    @AfterClass
    public static void tearDown() {
        process.stop();
    }

    @Before
    public void before() {
        flyway.migrate();
    }

    @After
    public void after() throws SQLException {
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
