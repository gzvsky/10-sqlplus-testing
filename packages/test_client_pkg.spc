create or replace package test_client_pkg is

    --%suite(Test client_pkg)
    --%suitepath(client)

    ----- СОЗДАНИЕ
    ----- кейсы для процедуры создания клиента create_client
    --%test(Создание клиента с валидными параметрами)
    --%aftertest(delete_test_client)
    procedure create_valid_client;

    --%test(Создание клиента без одного из обязательных параметров. Например: c_first_name := null)
    --%aftertest(delete_test_client)
    --%throws(-20100)
    procedure create_client_without_name;

    --%test(Создание клиента с неверным параметром c_gender)
    --%aftertest(delete_test_client)
    --%throws(-02290)
    procedure create_client_with_incorrect_gender;

    --%test(Создание клиента с датой рождения из будущего))
    --%aftertest(delete_test_client)
    --%throws(-02290)
    procedure create_client_with_future_birth_date;


    ----- ИЗМЕНЕНИЕ
    ----- кейсы для процедуры изменения клиента update_client
    --%test(Изменение существующего клиента)
    --%beforetest(create_test_client)
    --%aftertest(delete_test_client)
    procedure update_existing_client;

    --%test(Изменение несуществующего клиента)
    --%aftertest(delete_test_client)
    --%throws(-20404)
    procedure update_non_existing_client;

    --%test(Изменение клиента с датой посещения в прошлом)
    --%beforetest(create_test_client)
    --%aftertest(delete_test_client)
    --%throws(-02290)
    procedure update_existing_client_with_past_visit_date;

    --%test(Обновление с не заданным параметром id клиента приводит к ошибке)
    --%throws(-20100)
    procedure update_client_with_null_client_id;

    --%test(Обновление с не заданным параметром p_visit_date приводит к ошибке)
    --%beforetest(create_test_client)
    --%aftertest(delete_test_client)
    --%throws(-20100)
    procedure update_client_with_null_visit_date;


    ----- УДАЛЕНИЕ
    ----- кейсы для процедуры удаления клиента delete_client
    --%test(Удаление существующего клиента)
    --%beforetest(create_test_client)
    --%aftertest(delete_test_client)
    procedure delete_existing_client;

    --%test(Удаление несуществующего клиента приводит к ошибке)
    --%throws(-20404)
    procedure delete_non_existing_wallet;

    --%test(Удаление с не заданным параметром 'id клиента' приводит к ошибке)
    --%throws(-20100)
    procedure delete_client_with_null_client_id;


    ----- ДРУГОЙ ФУНКЦИОНАЛ
    --%test(Создание клиента не через API должно завершаться с ошибкой)
    --%throws(-20500)
    procedure insert_client_without_api_leads_to_error;

    --%test(Изменение клиента не через API должно завершаться с ошибкой)
    --%beforetest(create_test_client)
    --%aftertest(delete_test_client)
    --%throws(-20500)
    procedure update_client_without_api_leads_to_error;

    --%test(Удаление клиента не через API должно завершаться с ошибкой)
    --%beforetest(create_test_client)
    --%aftertest(delete_test_client)
    --%throws(-20500)
    procedure delete_client_without_api_leads_to_error;

    ----- ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ
    procedure create_test_client;
    procedure delete_test_client;
end;
/