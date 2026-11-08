# Linuxkurssi – viikko 2: kävijälaskuri

Python (Flask) -verkkosovellus, joka näyttää MySQL-tietokantaan tallentuvan käyntimäärän.

## Arkkitehtuuri

```
Selain → Nginx (portti 80)
           ├── /          → /var/www/html (viikko 1, staattinen)
           └── /viikko2/  → Gunicorn 127.0.0.1:5000 → Flask → MySQL
```

- **Nginx** toimii reverse proxyna, ja vain portti 80 on auki internetiin.
- **Gunicorn** ajaa Flask-sovellusta systemd-palveluna (`deploy/laskuri.service`).
- **MySQL**: jokainen sivun lataus lisää `visits`-tauluun rivin, ja käyntimäärä on `COUNT(*)`.
- Kaikki palvelut käynnistyvät automaattisesti systemd:n kautta.
- Tietokannan tunnukset ovat palvelimella tiedostossa `/etc/laskuri.env`, eivät repossa.

## Käyttöönotto (Ubuntu)

```bash
sudo apt install nginx mysql-server python3-venv
git clone https://github.com/Astrlol/linuxkurssi.git ~/linuxkurssi
cd ~/linuxkurssi
python3 -m venv venv
venv/bin/pip install -r requirements.txt

# Tietokanta: luo ensin tietokanta ja käyttäjä, sitten taulu
sudo mysql laskuri < schema.sql

# Tunnukset: kopioi malli ja vaihda salasana
sudo cp .env.example /etc/laskuri.env
sudo chmod 600 /etc/laskuri.env

# Palvelu ja Nginx
sudo cp deploy/laskuri.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable --now laskuri
# Lisää deploy/nginx-viikko2.conf:n sisältö Nginxin server-lohkoon
sudo nginx -t && sudo systemctl reload nginx
```

## Päivitys

```bash
cd ~/linuxkurssi && git pull && sudo systemctl restart laskuri
```