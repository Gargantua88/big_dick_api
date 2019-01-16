## Тестовое API на Rails

## Задание
Написать простое API на Rails для сайта
Требования для приложения следующие:
 
Базовые CRUD операции (создание, получение, изменение, удаление материалов). Получение материала по относительной ссылке, которая может содержать “/” (например /api/topics/относительная/ссылка.html).
Аутентификация по токену в заголовке или запросе
Фильтрация материалов по параметрам (рубрика, тэг, список ID)
Сортировка материалов ASC и DESC (по дате публикации, по ID)

Опциональные требования:
* Удобная для расширения документация API (Swagger, etc), которой будут пользоваться frontend-разработчики
* Рабочий Docker-образ приложения, готовый к деплою
* Покрытие тестами

 
Материал содержит:
 
Заголовок

Анонс

Обложку (относительную ссылку на обложку, прим: imgs/2018/03/12/314135135.jpg. Загружать обложку не надо)

Тело материала

Относительную ссылку (прим: /kotiki/persidskie/kak-kormit-kota.html)

Рубрику (slug и title)

Тэги (массив тэгов, содержащих slug и title)

Дату публикации

## Формат передачи параметров

Параметры для создания передаются только в полном объеме вместе с рубрикой и тегами.

Для создания материала передайте POST запрос на *[host]/materials*

Параметры для материала передаются как:

 ```?material[title]=...&material[link]=...```

Параметры для рубрики передаются как:
 
 ```=..material[heading][slug]=...&material[heading][title]=...```

Параметры для тегов передаются массивом:

```=...&material[tags][][title]=...&material[tags][][slug]=...&material[tags][][title]=...&material[tags][][slug]=...```

Для фильтрации материала, отправьте GET запрос на *[host]/materials* с нужным параметром/списком параметров(поддерживает список id,
тег, рубрика).

Для сортировки материала по id добавьте параметр
```=...&sort=id```

Для сортировки материала по published_date добавьте параметр 
```=...&sort=published_date```

Для сортировки материала по возрастанию добавьте параметр
```=...&order=asc```

Для сортировки материала по убыванию добавьте параметр
```=...&order=desc```

Получение материала по относительной ссылке производится запросом GET на *[host]/materials/[material.link]*,
либо на *[host]/materials/[material.id]*