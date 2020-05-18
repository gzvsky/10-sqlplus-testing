create or replace package client_pkg is

    -- коды ошибок
    c_error_code_wrong_input_param                  constant number := -20100;
    c_error_code_client_doesnt_exist                constant number := -20404;
    c_error_code_manual_change_forbidden            constant number := -20500;

    -- сообщения ошибок
    c_error_msg_wrong_input_param        constant varchar2(200 char) := 'Параметры не могут быть пустыми';
    c_error_msg_client_doesnt_exist      constant varchar2(200 char) := 'Такого клиента не существует';
    c_error_msg_manual_change_forbidden  constant varchar2(200 char) := 'Прямое изменение запрещено. Только через API пакета client_pkg';

    -- Добавление нового клиента
    function create_client(pi_first_name client.c_first_name%type, pi_last_name client.c_last_name%type, pi_middle_name client.c_middle_name%type, pi_gender client.c_gender%type, pi_birth_date client.c_birth_date%type, pi_autocommit boolean := false) return client.c_id%type;

    -- Обновление клиента
    function update_client(pi_client_id client.c_id%type, pi_visit_date client.c_last_visit_date%type, pi_autocommit boolean := false) return client.c_id%type;

    -- Удаление клиента
    function delete_client(pi_client_id client.c_id%type, pi_autocommit boolean := false) return client.c_id%type;

    -- Для триггера на запрет прямого изменения client
    procedure prevent_direct_change;
end;
/