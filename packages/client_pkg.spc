create or replace package client_pkg is

    -- Добавление нового клиента
    function createClient(pi_first_name client.c_first_name%type, pi_last_name client.c_last_name%type, pi_middle_name client.c_middle_name%type, pi_gender client.c_gender%type, pi_birth_date client.c_birth_date%type, pi_autocommit boolean := false) return client.c_id%type;

    -- Обновление клиента
    function updateClient(pi_client_id client.c_id%type, p_visit_date client.c_last_visit_date%type, pi_autocommit boolean := false) return client.c_id%type;

    -- Удаление клиента
    function deleteClient(pi_client_id client.c_id%type, pi_autocommit boolean := false) return client.c_id%type;

    -- Для триггера на запрет прямого изменения client
    procedure prevent_direct_change;
end;
/