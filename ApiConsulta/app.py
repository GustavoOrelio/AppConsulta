from flask import Flask, jsonify, request
import requests
from bs4 import BeautifulSoup
from urllib.parse import quote_plus, urlparse, parse_qs

app = Flask(__name__)

@app.route('/pesquisa', methods=['GET'])  # Mudança para português
def pesquisa():
    termo_pesquisa = request.args.get('query', '')
    if not termo_pesquisa:
        return jsonify({'erro': 'Termo de pesquisa ausente'}), 400

    termo_codificado = quote_plus(termo_pesquisa)
    url_google = f"https://www.google.com/search?q={termo_codificado}"

    cabecalhos = {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3"
    }

    resposta = requests.get(url_google, headers=cabecalhos)

    if resposta.status_code != 200:
        return jsonify({'erro': 'Falha ao buscar resultados de pesquisa'}), 500

    soup = BeautifulSoup(resposta.text, "html.parser")
    resultados_pesquisa = soup.find_all('div')

    resultados = []
    links_vistos = set()

    for resultado in resultados_pesquisa:
        elemento_titulo = resultado.find('h3')
        elemento_link = resultado.find('a')

        if elemento_titulo and elemento_link:
            link_bruto = elemento_link.get('href')
            link_analisado = urlparse(link_bruto)
            parametros_query = parse_qs(link_analisado.query)
            link_real = parametros_query.get('url', [None])[0]

            if link_real:
                link = link_real
                if link not in links_vistos:
                    links_vistos.add(link)
                    titulo = elemento_titulo.text
                    resultados.append({'titulo': titulo, 'link': link})

    return jsonify(resultados)

if __name__ == '__main__':
    app.run(debug=True)
