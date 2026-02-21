# Домашнее задание к занятию 15 «Система сбора логов Elastic Stack»

## Задание 1

Вам необходимо поднять в докере и связать между собой:

- elasticsearch (hot и warm ноды);
- logstash;
- kibana;
- filebeat.

Logstash следует сконфигурировать для приёма по tcp json-сообщений.

Filebeat следует сконфигурировать для отправки логов docker вашей системы в logstash.

В директории [help](./help) находится манифест docker-compose и конфигурации filebeat/logstash для быстрого 
выполнения этого задания.
![](https://i.yapx.ru/dAHQI.png)

Результатом выполнения задания должны быть:

- скриншот `docker ps` через 5 минут после старта всех контейнеров (их должно быть 5);
![](https://i.yapx.ru/dAHZL.png)
- скриншот интерфейса kibana;
![](https://i.yapx.ru/dAIiJ.png)

## Задание 2

Перейдите в меню [создания index-patterns  в kibana](http://localhost:5601/app/management/kibana/indexPatterns/create) и создайте несколько index-patterns из имеющихся.
![](https://i.yapx.ru/dAJBd.png)

Перейдите в меню просмотра логов в kibana (Discover) и самостоятельно изучите, как отображаются логи и как производить поиск по логам.
![](https://i.yapx.ru/dATq4.png)

В манифесте директории help также приведенно dummy-приложение, которое генерирует рандомные события в stdout-контейнера.
Эти логи должны порождать индекс logstash-* в elasticsearch. Если этого индекса нет — воспользуйтесь советами и источниками из раздела «Дополнительные ссылки» этого задания.
```
curl -s http://localhost:9200/_cat/indices/logstash-*?v&s=index
health status index               uuid                   pri rep docs.count docs.deleted store.size pri.store.size
yellow open   logstash-2026.02.09 _1r7CWFfRoGx3CxE7I3sHA   1   1      12725            0      5.3mb          5.3mb
yellow open   logstash-2026.02.06 wx4B620MTieypglKsteK1Q   1   1       2375            0      1.4mb          1.4mb
yellow open   logstash-2026.02.11 9B_Kkbs5QeCDUORz7LawhA   1   1      13553            0      5.3mb          5.3mb
yellow open   logstash-2026.02.12 t3L0jqbiQIeHnizaApEfAw   1   1       3535            0      1.5mb          1.5mb
yellow open   logstash-2026.02.13 dynAADEUQoiL-ehY-yqMbg   1   1      11318            0      4.6mb          4.6mb
yellow open   logstash-2026.02.14 CGKlUHGGRyOXo2EgrogI2w   1   1       1192            0    547.4kb        547.4kb
yellow open   logstash-2025.07.17 2n4vcgT4QsSUMnlRxYjJwQ   1   1         50            0    108.7kb        108.7kb
yellow open   logstash-2026.01.02 C6Y76ek2SaK3qBoJW9sTFQ   1   1          7            0     21.1kb         21.1kb
yellow open   logstash-2026.02.10 eKSx4LqlRj-OdHlGPePCUw   1   1       5892            0      2.8mb          2.8mb
yellow open   logstash-2025.12.08 3jIOGiQvTbK9XYnangtA7g   1   1        460            0    244.1kb        244.1kb
yellow open   logstash-2025.12.09 K5sUnJPnTO-56-RyewFw0A   1   1        267            0    198.2kb        198.2kb
yellow open   logstash-2025.12.04 9zj6SBiISCOLqKWMqrgUTQ   1   1         43            0     60.2kb         60.2kb
yellow open   logstash-2025.12.07 nLSCWYslQmucY19W2hAdyQ   1   1          9            0     25.1kb         25.1kb
yellow open   logstash-2025.12.11 7S_cd-cRRjKEbn6CsSYjcw   1   1        412            0    173.5kb        173.5kb
yellow open   logstash-2025.12.12 U4fG24y3TVKMXX5QfBaNgQ   1   1        534            0    248.4kb        248.4kb
yellow open   logstash-2025.12.13 bTqq1ue7SbuRegbr1Po3wQ   1   1        133            0    123.3kb        123.3kb
yellow open   logstash-2025.12.14 TWq3j44zR3yl8wE1ieGJKw   1   1         82            0    109.4kb        109.4kb
yellow open   logstash-2025.12.10 7y3ME6qeQOqm_VRzigFG8g   1   1        646            0    265.3kb        265.3kb
yellow open   logstash-2026.01.16 P6ckOcPLS0WEY3qSF5sU2Q   1   1         65            0    189.4kb        189.4kb
yellow open   logstash-2026.01.15 179_XnD1RTyMuZavljBFYQ   1   1        503            0    230.3kb        230.3kb
yellow open   logstash-2026.01.14 UcHYx7GjQ8mmev0d0HmjFA   1   1        797            0    153.4kb        153.4kb
yellow open   logstash-2025.12.19 eVig2SNyT1qNckSfoSuA9g   1   1         80            0     57.5kb         57.5kb
yellow open   logstash-2025.12.15 71-WwDCOR6G8U0rRj04_0w   1   1       1113            0    389.3kb        389.3kb
yellow open   logstash-2025.12.16 ZPdwqt94R0id_Tzeh8JFIg   1   1        587            0    275.2kb        275.2kb
yellow open   logstash-2025.12.17 6hfg7-2xQeuHInh-ig0a6g   1   1     253797            0     24.3mb         24.3mb
yellow open   logstash-2025.12.18 n_-jdJdEQZisEHD9uicy_w   1   1       1675            0    325.3kb        325.3kb
yellow open   logstash-2025.12.22 OpZe8wS7RvG78lcYvvi4SQ   1   1        674            0    283.7kb        283.7kb
yellow open   logstash-2025.12.23 b3UDTONXSoKG_4Q0-u2Cfg   1   1        150            0       93kb           93kb
yellow open   logstash-2025.12.24 bT_hf1JqQ3GvD4ZdA1Y6Lg   1   1        518            0      225kb          225kb
yellow open   logstash-2025.07.30 ZrpP3gM4RheCzoV4ehTEwg   1   1          3            0     20.5kb         20.5kb
yellow open   logstash-2025.12.25 MJa3f2UhQ_uhQwUHU4Xm3A   1   1        178            0     98.3kb         98.3kb
yellow open   logstash-2025.12.21 GGeCcccESt-l5Kupdugnww   1   1        121            0     69.2kb         69.2kb
yellow open   logstash-2026.02.19 ST906lYHS1GdMxLWrNN4Rw   1   1      10927            0      4.5mb          4.5mb
yellow open   logstash-2026.01.05 uKKnOwaaQbK3ifCcT6lYsw   1   1         97            0     60.3kb         60.3kb
yellow open   logstash-2026.02.15 iNVlCNCvRySluXsxVOL8CA   1   1       4788            0      2.1mb          2.1mb
yellow open   logstash-2026.01.09 B1-b-6pCRti1ZL4NZJI6Xw   1   1        722            0    298.1kb        298.1kb
yellow open   logstash-2026.02.16 XBjh0FhzQGSk7rqoYONgZQ   1   1      23131            0      8.8mb          8.8mb
yellow open   logstash-2026.01.08 omo_rfG6Rz2yTYr1TeGHGg   1   1        381            0    161.6kb        161.6kb
yellow open   logstash-2026.02.17 CZ_hBiCWQQi1QdPvPkRlYA   1   1      10552            0      4.3mb          4.3mb
yellow open   logstash-2026.02.18 bLIGf_sNSyeVZ3sxk3tYug   1   1      12131            0      4.8mb          4.8mb
yellow open   logstash-2025.12.26 eazom5sIRhyhtph-tyFhjQ   1   1        166            0     76.3kb         76.3kb
yellow open   logstash-2025.12.27 7xB59dqRR6qVG7Ag3XvjeA   1   1         48            0     29.3kb         29.3kb
yellow open   logstash-2025.12.29 G7immlm0RfSfueTpyFYw_A   1   1        429            0    137.1kb        137.1kb
yellow open   logstash-2025.12.30 HZpSxIt7QoOyjMgT-543cQ   1   1        143            0     69.7kb         69.7kb
yellow open   logstash-2025.09.29 28j-ASPZRrWJ5r89iYwJdQ   1   1        473            0    376.9kb        376.9kb
yellow open   logstash-2026.01.13 6JixRHIjQBu569Urp4lUvQ   1   1        554            0    250.8kb        250.8kb
yellow open   logstash-2026.01.12 -LYjnT7qQj2nL-USax-DGQ   1   1        511            0    181.1kb        181.1kb
yellow open   logstash-2026.01.11 4a6oKDT1TAS32r-GLt0aUQ   1   1        177            0     79.1kb         79.1kb
yellow open   logstash-2026.02.20 AVEBx8JpQbSO7yXk0GmaFA   1   1      12863            0      8.4mb          8.4mb
yellow open   logstash-2026.01.10 WayvT37tRKq57xohxlMHOQ   1   1        390            0     94.9kb         94.9kb
yellow open   logstash-2026.02.21 8Hdjp_izRrSt1fmDx5hEfg   1   1       1457            0      2.3mb          2.3mb
```
Индексы есть

---

### Как оформить решение задания

Выполненное домашнее задание пришлите в виде ссылки на .md-файл в вашем репозитории.

---

 
