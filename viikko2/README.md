# Viikko 2: kävijälaskuri

Flask-sovellus, joka tallentaa jokaisen sivun latauksen MySQL-tietokantaan ja näyttää latausten määrän.

Sivu: http://195.148.20.88/viikko2/

## Miten se toimii

```
Selain → Nginx → Gunicorn (127.0.0.1:5000) → Flask → MySQL
```

Jokainen lataus lisää `visits`-tauluun rivin. Sivulla näkyvä luku on rivien määrä.

## Tiedostot

| Tiedosto | Mitä |
|---|---|
| `laskuri.py` | Sovellus |
| `templates/index.html` | Sivun pohja |
| `schema.sql` | Tietokannan taulu |
| `requirements.txt` | Python-paketit |
| `.env.example` | Malli tunnuksille. Oikea tiedosto on palvelimella `/etc/laskuri.env`. |
| `deploy/laskuri.service` | systemd-palvelu |
| `deploy/nginx-viikko2.conf` | Nginx-lohko |

## Käyttöönotto

```bash
cd ~/linuxkurssi
python3 -m venv venv
venv/bin/pip install -r viikko2/requirements.txt

# Tietokanta ja käyttäjä luodaan ensin MySQL:ssä, sitten taulu:
sudo mysql laskuri < viikko2/schema.sql

# Tunnukset (vaihda salasana):
sudo cp viikko2/.env.example /etc/laskuri.env
sudo chmod 600 /etc/laskuri.env

# Palvelu:
sudo cp viikko2/deploy/laskuri.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable --now laskuri
```

Lisää `deploy/nginx-viikko2.conf`:n sisältö Nginxin `server`-lohkoon ja aja `sudo nginx -t && sudo systemctl reload nginx`.

## Päivitys

```bash
git pull
sudo systemctl restart laskuri
```
