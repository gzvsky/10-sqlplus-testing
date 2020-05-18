create or replace package body client_pkg is

    g_is_api boolean:= false;

    -- Добавление нового клиента
    function create_client(
        pi_first_name client.c_first_name%type,
        pi_last_name client.c_last_name%type,
        pi_middle_name client.c_middle_name%type,
        pi_gender client.c_gender%type,
        pi_birth_date client.c_birth_date%type,
        pi_autocommit boolean := false
    ) return client.c_id%type
        is
        v_id client.c_id%type;
    begin
        -- проверяем входные параметры
        if pi_first_name is null
            or pi_last_name is null
            or pi_gender is null
            or pi_birth_date is null
        then
          raise_application_error(c_error_code_wrong_input_param,
                                  c_error_msg_wrong_input_param);
        end if;

        g_is_api := true;

        v_id := client_seq.nextval;
        insert into client values (v_id, pi_first_name, pi_last_name, pi_middle_name, pi_gender, pi_birth_date, sysdate, sysdate);

        if pi_autocommit then
            commit;
        end if;

        g_is_api := false;

        return v_id;

        exception
        when others then
            g_is_api := false;
            raise;
    end;

    -- Обновление клиента
    function update_client(pi_client_id client.c_id%type, pi_visit_date client.c_last_visit_date%type, pi_autocommit boolean := false) return client.c_id%type
        is
        v_temp_id client.c_id%type;
    begin
        -- проверяем входные параметры
        if pi_client_id is null
           or pi_visit_date is null
        then
            raise_application_error(c_error_code_wrong_input_param,
                                    c_error_msg_wrong_input_param);
        end if;
        g_is_api := true;

        update client set c_last_visit_date = pi_visit_date where c_id = pi_client_id returning c_id into v_temp_id;

        if v_temp_id is null then
            raise_application_error(c_error_code_client_doesnt_exist,
                                    c_error_msg_client_doesnt_exist);
        end if;

        if pi_autocommit then
            commit;
        end if;

        g_is_api := false;

        return pi_client_id;

        exception
        when others then
            g_is_api := false;
            raise;
    end;

    -- Удаление клиента
    function delete_client(pi_client_id client.c_id%type, pi_autocommit boolean := false) return client.c_id%type
        is
        v_id client.c_id%type;
    begin
        -- проверяем входные параметры
        if pi_client_id is null
        then
          raise_application_error(c_error_code_wrong_input_param,
                                  c_error_msg_wrong_input_param);
        end if;
        g_is_api := true;

        delete from client where c_id = pi_client_id returning c_id into v_id;
        if (v_id is null) then
            raise_application_error(c_error_code_client_doesnt_exist,
                                    c_error_msg_client_doesnt_exist);
        end if;

        if pi_autocommit then
            commit;
        end if;

        g_is_api := false;

        return v_id;

        exception
        when others then
            g_is_api := false;
            raise;
    end;

    procedure prevent_direct_change is
    begin
        if not (g_is_api or nvl(sys_context('clientcontext', 'force_dml'), 'false') = 'true')
        then
            raise_application_error(c_error_code_manual_change_forbidden,
                                    c_error_msg_manual_change_forbidden);
        end if;
    end;

end;
/