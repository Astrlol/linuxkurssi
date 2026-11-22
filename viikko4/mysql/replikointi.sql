-- Replikoinnin pystytys. Komennot ajetaan käsin, ei yhtenä tiedostona.
-- Salasanat ja osoitteet ovat paikkamerkkejä.

-- ===== Palvelin A =====

-- Replikointikäyttäjä: vain B:n osoitteesta ja salatulla yhteydellä
CREATE USER 'replikointi'@'B_SISAVERKON_IP' IDENTIFIED BY 'SALASANA' REQUIRE SSL;
GRANT REPLICATION SLAVE ON *.* TO 'replikointi'@'B_SISAVERKON_IP';

-- B:n sivun lukukäyttäjä. Luodaan A:lla, jolloin se replikoituu B:lle.
CREATE USER 'lukija'@'localhost' IDENTIFIED BY 'SALASANA';
GRANT SELECT ON laskuri.visits TO 'lukija'@'localhost';

-- Alustuskopio A:lla (komentorivillä, ei MySQL:ssä):
--   sudo mysqldump --single-transaction --set-gtid-purged=ON --databases laskuri > laskuri-alustus.sql
-- Kopio siirretään B:lle ja poistetaan käytön jälkeen.

-- ===== Palvelin B =====

SET GLOBAL super_read_only = OFF;
RESET BINARY LOGS AND GTIDS;
SOURCE /home/ubuntu/laskuri-alustus.sql;

CHANGE REPLICATION SOURCE TO
  SOURCE_HOST = 'A_SISAVERKON_IP',
  SOURCE_PORT = 3306,
  SOURCE_USER = 'replikointi',
  SOURCE_PASSWORD = 'SALASANA',
  SOURCE_AUTO_POSITION = 1,
  SOURCE_SSL = 1;

START REPLICA;
SET GLOBAL super_read_only = ON;

-- Tarkistus: SHOW REPLICA STATUS\G
-- Replica_IO_Running: Yes, Replica_SQL_Running: Yes, Seconds_Behind_Source: 0
