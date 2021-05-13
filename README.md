# Residential Transaction Data

Source database: [RI Exeter public database](http://gis.vgsi.com/exeterri/Sales.aspx)

Dolthub reference: https://www.dolthub.com/repositories/max-hoffman/exeter-ri-houses

Dolt install:

```bash
sudo bash -c 'curl -L https://github.com/dolthub/dolt/releases/latest/download/install.sh | sudo bash'
```

Create dataset:

```bash
./scripts/ populate_db.sh
```

Sample diffs:

Human-readable cli diff:
```bash
$ dolt diff HEAD^ HEAD --limit 5
diff --dolt a/latest_sale b/latest_sale
--- a/latest_sale @ q5brka8t250mn32bjeim2bs59sooqmai
+++ b/latest_sale @ egvi8ugoj7cg99pnf3b4ec2k4vosb60n
+-----+--------------------+------------+------------+-------------+----------+-------------+----------------+------+
|     | Location           | Sale Date  | Sale Price | Model       | Style    | Living Area | Land Area (SF) | Nbhd |
+-----+--------------------+------------+------------+-------------+----------+-------------+----------------+------+
|  +  | 1 HEMLOCK DR       | 09/28/2020 | 450000     | Residential | Ranch    | 2064        | 15202          | 05   |
|  +  | 1 MOCKINGBIRD DR   | 11/20/2020 | 385000     | Residential | R Ranch  | 1536        | 11979          | 05   |
|  +  | 1 PINOAK DR        | 07/15/2020 | 375000     | Residential | Colonial | 1728        | 13590          | 05   |
|  <  | 1 WIDOW SWEETS RD  | 02/27/2019 | 160000     | Residential | Ranch    | 1855        | 455202         | 06   |
|  >  | 1 WIDOW SWEETS RD  | 08/07/2020 | 522500     | Residential | Ranch    | 1855        | 455202         | 06   |
|  +  | 10 OAKHILL DR      | 09/11/2020 | 369000     | Residential | R Ranch  | 1144        | 16030          | 05   |
+-----+--------------------+------------+------------+-------------+----------+-------------+----------------+------+
```

System-table SQL diff:
```bash
$ dolt sql -q "
    select `to_Location`, `to_Model`, `from_Sale Price`,`to_Sale Price`
    from dolt_commit_diff_latest_sale
    where from_commit = HASHOF('HEAD^') and
          to_commit = HASHOF('HEAD') and
          diff_type = 'modified' limit 5"
+-----------------------+-------------+-----------------+---------------+
| to_Location           | to_Model    | from_Sale Price | to_Sale Price |
+-----------------------+-------------+-----------------+---------------+
| 1 WIDOW SWEETS RD     | Residential | 160000          | 522500        |
| 119 LOCUST VALLEY RD  | Residential | 470000          | 610000        |
| 126 MAIL RD           | Residential | 515000          | 535000        |
| 20 MOCKINGBIRD DR     | Residential | 285000          | 370000        |
| 249 PURGATORY RD      | Residential | 345000          | 429000        |
+-----------------------+-------------+-----------------+---------------+
```
