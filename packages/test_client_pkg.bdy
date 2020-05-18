create or replace package body test_client_pkg is

    g_client_id client.c_id%type;

    -- получить несуществующего клиента
    function get_non_exists_client return client.c_id%type
        is
        v_count number;
        v_client_id client.c_id%type;
    begin
        v_count := 1;
        while v_count > 0
        loop
            v_client_id := -dbms_random.value(10000, 2000000);
            select count(*) into v_count from client where c_id = v_client_id;
        end loop;

        return v_client_id;
    end;



    ----- СОЗДАНИЕ
    ----- кейсы для процедуры создания клиента create_client
    procedure create_valid_client
        is
        v_first_name        client.c_first_name%type := 'test_name';
        v_last_name         client.c_last_name%type := 'test_last_name';
        v_middle_name        client.c_middle_name%type := null;
        v_gender            client.c_gender%type := 'M';
        v_birth_date        client.c_birth_date%type := sysdate;
        v_client_row        client%rowtype;
    begin
        g_client_id := client_pkg.create_client(
            pi_first_name => v_first_name,
            pi_last_name => v_last_name,
            pi_middle_name => v_middle_name,
            pi_birth_date => v_birth_date,
            pi_gender => v_gender
            );
        select * into v_client_row from client where c_id = g_client_id;

        ut.expect(v_first_name).to_equal(v_client_row.c_first_name);
        ut.expect(v_last_name).to_equal(v_client_row.c_last_name);
        ut.expect(v_middle_name).to_equal(v_client_row.c_middle_name);
        ut.expect(v_gender).to_equal(v_client_row.c_gender);
        ut.expect(v_birth_date).to_equal(v_client_row.c_birth_date);
    end;

    procedure create_client_without_name
        is
        v_first_name        client.c_first_name%type := null;
        v_last_name         client.c_last_name%type := 'test_last_name';
        v_middle_name       client.c_middle_name%type := null;
        v_gender            client.c_gender%type := 'M';
        v_birth_date        client.c_birth_date%type := sysdate;
        v_client_row        client%rowtype;
    begin
        g_client_id := client_pkg.create_client(
            pi_first_name => v_first_name,
            pi_last_name => v_last_name,
            pi_middle_name => v_middle_name,
            pi_birth_date => v_birth_date,
            pi_gender => v_gender
            );
    end;

    procedure create_client_with_incorrect_gender
        is
        v_first_name        client.c_first_name%type := 'test_name';
        v_last_name         client.c_last_name%type := 'test_last_name';
        v_middle_name        client.c_middle_name%type := null;
        v_gender            client.c_gender%type := 'Q';
        v_birth_date        client.c_birth_date%type := sysdate;
        v_client_row        client%rowtype;
    begin
        g_client_id := client_pkg.create_client(
            pi_first_name => v_first_name,
            pi_last_name => v_last_name,
            pi_middle_name => v_middle_name,
            pi_birth_date => v_birth_date,
            pi_gender => v_gender
            );
    end;

    procedure create_client_with_future_birth_date
        is
        v_first_name        client.c_first_name%type := 'test_name';
        v_last_name         client.c_last_name%type := 'test_last_name';
        v_middle_name        client.c_middle_name%type := null;
        v_gender            client.c_gender%type := 'M';
        v_birth_date        client.c_birth_date%type := sysdate + 15000;
    begin
        g_client_id := client_pkg.create_client(
            pi_first_name => v_first_name,
            pi_last_name => v_last_name,
            pi_middle_name => v_middle_name,
            pi_birth_date => v_birth_date,
            pi_gender => v_gender
            );
    end;



    ----- ИЗМЕНЕНИЕ
    ----- кейсы для процедуры изменения клиента update_client
    procedure update_existing_client
        is
        v_temp_date client.c_last_visit_date%type;
        v_temp_id client.c_id%type;
        v_validation_of_date client.c_last_visit_date%type;
    begin
        v_temp_date := sysdate;
        v_temp_id := client_pkg.update_client(
            pi_client_id => g_client_id
            ,pi_visit_date => v_temp_date);

        select c_last_visit_date into v_validation_of_date from client where c_id = v_temp_id;

        ut.expect(v_temp_id).to_equal(g_client_id);
        ut.expect(v_validation_of_date).to_equal(v_temp_date);
    end;

    procedure update_non_existing_client
        is
        v_client_id client.c_id%type;
    begin
        v_client_id := get_non_exists_client();
        g_client_id := client_pkg.update_client(
            pi_client_id => v_client_id
            ,pi_visit_date => sysdate);
    end;

    procedure update_existing_client_with_past_visit_date
        is
        v_client_id client.c_id%type;
    begin
        v_client_id := client_pkg.update_client(
            pi_client_id => g_client_id,
            pi_visit_date => sysdate - 15000);
    end;

    procedure update_client_with_null_client_id
        is
        v_client_id client.c_id%type;
    begin
        v_client_id := client_pkg.update_client(
            pi_client_id => null
            ,pi_visit_date => sysdate);
    end;

    procedure update_client_with_null_visit_date
        is
    begin
        g_client_id := client_pkg.update_client(
            pi_client_id => g_client_id
            ,pi_visit_date => null);
    end;



    ----- УДАЛЕНИЕ
    ----- кейсы для процедуры удаления клиента delete_client
    procedure delete_existing_client
        is
        v_count number;
        v_temp_id client.c_id%type := null;
    begin
        v_temp_id := client_pkg.delete_client(
            pi_client_id => g_client_id
            );

        ut.expect(v_temp_id).not_to(be_null());

        select count(*) into v_count
        from client where c_id = g_client_id;

        ut.expect(v_count).to_equal(0);
    end;

    procedure delete_non_existing_wallet
        is
        v_client_id client.c_id%type;
    begin
        v_client_id := get_non_exists_client();
        g_client_id := client_pkg.delete_client(v_client_id);
    end;

    procedure delete_client_with_null_client_id
        is
    begin
        g_client_id := client_pkg.delete_client(null);
    end;




    ----- ДРУГОЙ ФУНКЦИОНАЛ
    procedure insert_client_without_api_leads_to_error
        is
        v_non_existing_id client.c_id%type;
    begin
        v_non_existing_id := get_non_exists_client();
        insert into client
        values (v_non_existing_id
                ,'test'
                ,'test'
                ,'test'
                ,'M'
                , sysdate
                , sysdate
                , sysdate);
    end;

    procedure update_client_without_api_leads_to_error
        is
        v_id client.c_id%type;
    begin
        select c_id into v_id from client where c_id = g_client_id;
        if v_id is null then
            return;
        end if;
        update client set c_last_visit_date = sysdate where c_id = v_id;
    end;

    procedure delete_client_without_api_leads_to_error
        is
        v_id client.c_id%type;
    begin
        select c_id into v_id from client where c_id = g_client_id;
        if v_id is null then
            return;
        end if;
        delete client where c_id = v_id;
    end;


    

    ----- ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ
    procedure create_test_client
        is
    begin
        dbms_session.set_context('clientcontext', 'force_dml', 'true');

        insert into client (c_id
                            , c_first_name
                            , c_last_name
                            , c_middle_name
                            , c_gender
                            , c_birth_date
                            , c_created_at_date
                            , c_last_visit_date)
        values (client_seq.nextval
                ,'test_name'
                ,'test_last_name'
                ,'test_middle_name'
                ,'M'
                , sysdate
                , sysdate
                , sysdate)
        returning c_id into g_client_id;

        dbms_session.set_context('clientcontext', 'force_dml', 'false');
        exception
        when others then
            dbms_session.set_context('clientcontext', 'force_dml', 'false');
    end;

    procedure delete_test_client
        is
    begin
        if g_client_id is null
        then
            return;
        end if;

        dbms_session.set_context('clientcontext', 'force_dml', 'true');

        delete client where c_id = g_client_id;

        g_client_id := null;
        dbms_session.set_context('clientcontext', 'force_dml', 'false');
        exception
        when others then
            dbms_session.set_context('clientcontext', 'force_dml', 'false');
    end;

end;
/