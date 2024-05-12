from flask import Flask, request, jsonify
import json
import sqlite3

app = Flask(__name__)

@app.route('/', methods=['GET'])
def index():
    return 'Serveur en ligne'

@app.route('/ajouter_resto', methods=['POST'])
def ajouter_resto():
    try:
        data = json.loads(request.data)
        nomResto = data.get('nom')
        adresse = data.get('adresse')

        if nomResto is None or adresse is None:
            return 'Missing required fields: nom or adresse', 400

        enregistrer_resto(nomResto, adresse)
        return 'Restaurant ajouté avec succès', 200
    except json.JSONDecodeError:
        return 'Invalid JSON format', 400

@app.route('/ajouterPlats', methods=['POST'])
def ajouter_plats():
    try:
        data = json.loads(request.data)

        connection = sqlite3.connect('serveur.db')
        cursor = connection.cursor()

        for nom_resto, plats in data.items():
            for plat in plats:
                nom_plat, ingredients, couleur, prix = plat
                cursor.execute('INSERT INTO plat (nom, couleur, ingredients, prix) VALUES (?, ?, ?, ?)',
                               (nom_plat, couleur, ingredients, prix))
                cursor.execute('INSERT INTO propose (nomResto, nom) VALUES (?, ?)', (nom_resto, nom_plat))

        connection.commit()
        return 'Données enregistrées avec succès', 200
    except Exception as e:
        return f'Erreur lors de l\'enregistrement des données : {str(e)}', 500
    

@app.route('/plats/<nom_resto>', methods=['GET'])
def get_plats_by_resto(nom_resto):
    try:
        connection = sqlite3.connect('serveur.db')
        cursor = connection.cursor()

        # Sélectionne les plats proposés par le restaurant spécifié
        cursor.execute('SELECT plat.nom, plat.ingredients, plat.couleur, plat.prix FROM plat INNER JOIN propose ON plat.nom = propose.nom WHERE propose.nomResto = ?', (nom_resto,))
        plats = cursor.fetchall()

        connection.close()

        # Crée un dictionnaire contenant les plats
        plats_dict = [{'nom': plat[0], 'ingredients': plat[1], 'couleur': plat[2], 'prix': plat[3]} for plat in plats]

        return jsonify(plats_dict)
    except Exception as e:
        return jsonify({'error': str(e)}), 500






def enregistrer_resto(nomResto, adresse):
    print(f'Nom du restaurant: {nomResto}')
    print(f'Adresse du restaurant: {adresse}')

    database_path = 'serveur.db'
    connection = sqlite3.connect(database_path)
    cursor = connection.cursor()

    cursor.execute('CREATE TABLE IF NOT EXISTS resto (id INTEGER PRIMARY KEY, nomResto TEXT, adresse TEXT)')

    cursor.execute('INSERT INTO resto (nomResto, adresse) VALUES (?, ?)', (nomResto, adresse))
    connection.commit()

    cursor.execute('SELECT * FROM resto WHERE nomResto = ? AND adresse = ?', (nomResto, adresse))
    results = cursor.fetchall()

    if results:
        print('Données insérées avec succès dans la base de données.')
    else:
        print("Erreur lors de l'insertion des données dans la base de données.")

    connection.close()

if __name__ == '__main__':
    app.run(host='192.168.50.113', port=8080)
