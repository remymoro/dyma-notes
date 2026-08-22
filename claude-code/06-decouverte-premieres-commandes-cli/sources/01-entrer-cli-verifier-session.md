# Entrer dans le CLI et préparer une première session saine

Dans cette leçon, vous allez démarrer une première session avec Claude Code, vérifier que l'environnement est prêt, et préparer un mini-projet qui servira de fil rouge pour les leçons suivantes. L'objectif n'est pas encore de modifier du code. L'objectif est de construire une base simple, stable et vérifiable avant de demander à Claude de travailler dans un dépôt.

Le chapitre va suivre un exemple volontairement très simple : un petit **convertisseur de température** entre Celsius et Fahrenheit. Ce n'est pas une todo list, ce n'est pas une application complète, et ce n'est pas un projet artificiellement complexe.

## Les commandes de cette leçon

Cette première leçon utilise cinq commandes principales : `/login`, `/status`, `/doctor`, `/help` et `/powerup`.

`/login` permet de se connecter à son compte. `/status` permet de vérifier l'état de la session, le modèle, le compte, la version et la connectivité. `/doctor` permet de diagnostiquer l'installation, les paramètres et les problèmes réparables. `/help` permet d'afficher l'aide et les commandes disponibles. `/powerup` lance un parcours interactif de découverte des capacités de Claude Code.

Il faut retenir une idée simple : avant de demander à Claude d'agir sur un projet, il faut vérifier que la session est saine. Une mauvaise authentification, une connectivité instable ou une configuration incorrecte peuvent créer de la confusion avant même la première demande de code.

## Préparer le mini-projet du chapitre

Avant d'ouvrir Claude Code, on prépare un petit dépôt local. Le projet s'appellera `convertisseur-temperature`.

### Créer le dossier du projet

```bash
mkdir convertisseur-temperature
cd convertisseur-temperature
```

### Créer le fichier package.json

On initialise ensuite un projet npm minimal. Le but n'est pas d'installer un framework. Le but est de disposer d'un projet JavaScript assez réaliste pour lancer des scripts, lire un `package.json`, exécuter un test et ouvrir une page dans le navigateur.

```bash
cat > package.json <<'EOF'
{
  "name": "convertisseur-temperature",
  "version": "1.0.0",
  "description": "Mini projet pour découvrir Claude Code",
  "type": "module",
  "scripts": {
    "test": "node --test",
    "dev": "node server.js"
  }
}
EOF
```

### Créer la logique de conversion

```bash
mkdir -p src test

cat > src/conversion.js <<'EOF'
export function convertirCelsiusEnFahrenheit(celsius) {
  return celsius * 9 / 5 + 32;
}

export function convertirFahrenheitEnCelsius(fahrenheit) {
  return (fahrenheit - 32) * 5 / 9;
}

export function arrondirTemperature(valeur) {
  return Math.round(valeur * 10) / 10;
}
EOF
```

Ce fichier contient seulement trois fonctions. C'est volontaire. Pour une première session, il ne faut pas chercher à impressionner avec un projet compliqué. Il faut donner à Claude un dépôt assez petit pour que ses premières actions soient observables.

### Créer le test

```bash
cat > test/conversion.test.js <<'EOF'
import test from 'node:test';
import assert from 'node:assert/strict';
import {
  convertirCelsiusEnFahrenheit,
  convertirFahrenheitEnCelsius,
  arrondirTemperature
} from '../src/conversion.js';

test('convertit les degrés Celsius en degrés Fahrenheit', () => {
  assert.equal(convertirCelsiusEnFahrenheit(0), 32);
  assert.equal(convertirCelsiusEnFahrenheit(100), 212);
});

test('convertit les degrés Fahrenheit en degrés Celsius', () => {
  assert.equal(convertirFahrenheitEnCelsius(32), 0);
  assert.equal(convertirFahrenheitEnCelsius(212), 100);
});

test('arrondit une température à un chiffre après la virgule', () => {
  assert.equal(arrondirTemperature(12.34), 12.3);
  assert.equal(arrondirTemperature(12.36), 12.4);
});
EOF
```

Le test sert de preuve minimale. Dès le début du chapitre, l'apprenant doit comprendre que Claude Code devient plus utile quand il peut vérifier son travail. Ici, la vérification est simple : `npm test`.

### Créer la page HTML

```bash
cat > index.html <<'EOF'
<!doctype html>
<html lang="fr">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Convertisseur de température</title>
  </head>
  <body>
    <main>
      <h1>Convertisseur de température</h1>
      <label for="temperature">Température en Celsius</label>
      <input id="temperature" type="number" value="20">
      <button id="convertir">Convertir</button>
      <p id="resultat">20 °C correspondent à 68 °F.</p>
    </main>
    <script type="module" src="./src/main.js"></script>
  </body>
</html>
EOF
```

### Créer le fichier JavaScript du navigateur

```bash
cat > src/main.js <<'EOF'
import {
  convertirCelsiusEnFahrenheit,
  arrondirTemperature
} from './conversion.js';

const champTemperature = document.querySelector('#temperature');
const boutonConvertir = document.querySelector('#convertir');
const paragrapheResultat = document.querySelector('#resultat');

function afficherConversion() {
  const temperatureCelsius = Number(champTemperature.value);
  const temperatureFahrenheit = arrondirTemperature(
    convertirCelsiusEnFahrenheit(temperatureCelsius)
  );
  paragrapheResultat.textContent =
    `${temperatureCelsius} °C correspondent à ${temperatureFahrenheit} °F.`;
}

boutonConvertir.addEventListener('click', afficherConversion);
EOF
```

### Créer un petit serveur de développement

```bash
cat > server.js <<'EOF'
import { createServer } from 'node:http';
import { readFile } from 'node:fs/promises';
import { extname, join } from 'node:path';

const port = 5173;
const racine = process.cwd();

const typesDeContenu = {
  '.html': 'text/html; charset=utf-8',
  '.js': 'text/javascript; charset=utf-8'
};

const serveur = createServer(async (requete, reponse) => {
  const cheminDemande = requete.url === '/' ? '/index.html' : requete.url;
  const cheminFichier = join(racine, cheminDemande);
  try {
    const contenu = await readFile(cheminFichier);
    const extension = extname(cheminFichier);
    reponse.writeHead(200, {
      'Content-Type': typesDeContenu[extension] || 'text/plain; charset=utf-8'
    });
    reponse.end(contenu);
  } catch {
    reponse.writeHead(404, {
      'Content-Type': 'text/plain; charset=utf-8'
    });
    reponse.end('Fichier introuvable.');
  }
});

serveur.listen(port, () => {
  console.log(`Serveur de développement disponible sur http://localhost:${port}`);
});
EOF
```

Ce serveur est volontairement minimal. Il ne remplace pas un vrai outil comme Vite, mais il suffit pour ouvrir la page dans un navigateur et préparer les leçons suivantes. L'objectif pédagogique est de garder le projet transparent : peu de fichiers, peu de dépendances et une vérification facile.

### Ajouter un README

```bash
cat > README.md <<'EOF'
# Convertisseur de température

Ce projet sert de support simple pour découvrir Claude Code.

## Fonctionnalités

- Convertir une température de Celsius vers Fahrenheit.
- Convertir une température de Fahrenheit vers Celsius.
- Arrondir une température à un chiffre après la virgule.
- Afficher une conversion simple dans une page HTML.

## Commandes utiles

Lancer les tests :

```bash
npm test
```

Lancer le serveur de développement :

```bash
npm run dev
```

Ouvrir ensuite :

```
http://localhost:5173
```
EOF
```

### Ignorer les fichiers inutiles

```bash
cat > .gitignore <<'EOF'
node_modules
.DS_Store
EOF
```

## Vérifier le projet avant d'ouvrir Claude Code

Avant de lancer Claude Code, il faut vérifier que le mini-projet fonctionne sans l'aide de l'agent. Cette étape évite de confondre un problème de projet avec un problème de CLI.

```bash
npm test
```

La sortie attendue doit indiquer que les tests passent. Le détail exact peut varier selon la version de Node.js, mais l'idée reste la même : les tests doivent réussir avant la première session avec Claude.

On peut aussi vérifier que la page se lance correctement.

```bash
npm run dev
```

Dans un navigateur, on ouvre ensuite `http://localhost:5173`. La page doit afficher un champ numérique, un bouton de conversion et un résultat en Fahrenheit. Une fois cette vérification faite, on peut arrêter le serveur avec `Ctrl+C`.

## Initialiser le dépôt Git

Le projet doit maintenant être placé dans un dépôt Git. Ce n'est pas obligatoire pour ouvrir Claude Code, mais c'est un très bon réflexe. Avec Git, il devient possible de voir précisément ce que Claude modifie, de comparer le diff et de revenir en arrière si nécessaire.

```bash
git init
git add .
git commit -m "Prépare le convertisseur de température"
```

## Ouvrir Claude Code dans le bon dossier

Une fois le projet prêt, on lance Claude Code depuis la racine du dépôt. Ce détail est important : si le CLI est lancé depuis le mauvais dossier, Claude ne verra pas le bon contexte et pourra analyser un autre répertoire.

```bash
claude
```

À partir de ce moment, les commandes qui commencent par `/` sont des commandes de session. Elles ne sont pas des commandes du terminal classique. Elles servent à piloter Claude Code depuis l'intérieur de l'interface interactive.

## Se connecter avec /login

La première commande à connaître est `/login`. Elle sert à se connecter au compte utilisé par Claude Code. Dans une première session, elle permet de vérifier que l'authentification est bien en place avant de demander à l'agent de lire le dépôt.

Si l'utilisateur est déjà connecté, la commande peut ne pas être nécessaire. Mais elle reste importante à connaître, surtout sur une nouvelle machine, une session fraîche, un environnement de formation ou un poste partagé.

```text
/login
```

Cette commande ne modifie pas le projet. Elle concerne le compte, pas les fichiers du dépôt. C'est une distinction importante : certaines commandes slash pilotent la session ou le compte, tandis que les demandes en langage naturel peuvent amener Claude à lire, exécuter ou modifier du code selon les permissions accordées.

## Vérifier l'état avec /status

Une fois connecté, la commande `/status` permet de vérifier l'état de la session. Elle donne un aperçu utile de la version, du compte, du modèle et de la connectivité.

Cette commande doit devenir un réflexe de début de session. Elle répond à une question simple : est-ce que Claude Code semble prêt à travailler dans ce contexte ?

Dans une formation, `/status` est aussi utile pour éviter les confusions. Deux apprenants peuvent avoir des versions différentes, des comptes différents, des plans différents ou des paramètres différents. Avant de comparer leurs résultats, il faut d'abord savoir dans quel état se trouve chaque session.

```text
/status
```

## Diagnostiquer avec /doctor

La commande `/doctor` sert à diagnostiquer l'installation et les paramètres. Elle est particulièrement utile au début, parce qu'elle permet de repérer des problèmes avant qu'ils ne deviennent des erreurs difficiles à interpréter.

Cette commande peut signaler des problèmes liés à l'installation, à l'authentification, à la connectivité, aux paramètres ou à l'environnement. Selon le résultat affiché, Claude Code peut aussi proposer de corriger certains problèmes réparables.

```text
/doctor
```

Le bon réflexe est le suivant : si une première session se comporte étrangement, on ne commence pas par réécrire le prompt. On lance d'abord `/doctor`. Si l'environnement est défaillant, un meilleur prompt ne corrigera pas le problème.

*[Exemple de lecture du diagnostic — capture d'écran non retranscrite]*

## Afficher l'aide avec /help

La commande `/help` affiche l'aide et les commandes disponibles. Elle doit être présentée tôt, parce que Claude Code évolue rapidement. Il ne faut pas apprendre le CLI comme une liste figée que l'on mémorise une fois pour toutes.

```text
/help
```

L'aide sert à vérifier les commandes disponibles dans la session réelle. Certaines commandes peuvent dépendre de la version, du plan, de la plateforme ou de l'environnement. La bonne source, pendant une session, reste donc l'aide affichée par le CLI lui-même.

Dans cette leçon, l'apprenant n'a pas besoin de comprendre toutes les commandes visibles. Il doit seulement comprendre comment les retrouver. Le reste du chapitre les introduira progressivement, dans un ordre lié aux usages.

## Découvrir les capacités avec /powerup

La commande `/powerup` lance un parcours interactif de découverte. Elle ne sert pas à modifier le mini-projet. Elle sert à présenter rapidement les capacités importantes de Claude Code.

```text
/powerup
```

Cette commande doit être utilisée comme une visite guidée. Elle peut présenter des notions qui seront étudiées plus tard : parler au codebase, changer de mode, utiliser le rewind, gérer des tâches, comprendre la mémoire, découvrir MCP, les skills, les hooks, les sous-agents, le remote, les modèles et l'effort.

Il ne faut pas essayer de tout maîtriser pendant cette première leçon. `/powerup` sert seulement à donner une carte mentale. Les détails viendront plus tard, quand chaque notion aura un vrai cas d'usage.

## Première demande sans modification

Après la préparation du projet et les commandes de diagnostic, on peut envoyer une première vraie demande à Claude. Cette demande doit rester en lecture seule. Elle sert à vérifier que Claude voit le bon dépôt et comprend le mini-projet.

Ce prompt est volontairement prudent. Il demande à Claude de lire, mais pas d'écrire. Il ne donne pas encore de tâche de développement. Il installe le réflexe central du chapitre : comprendre d'abord, modifier ensuite.

```text
Sans modifier de fichiers, confirme que tu es dans le bon projet.

Lis uniquement :
- package.json ;
- README.md ;
- l'arborescence du projet ;
- les fichiers dans src ;
- les fichiers dans test.

Termine par un résumé court :
1. rôle du projet ;
2. commandes disponibles ;
3. fichiers importants ;
4. vérification que je devrai lancer avant toute modification.
```

À ce stade, Claude devrait identifier que le projet convertit des températures, que la logique principale se trouve dans `src/conversion.js`, que l'interface utilise `src/main.js`, que les tests sont dans `test/conversion.test.js`, et que la commande de vérification principale est `npm test`.

*[Élément d'interface : lien "Code sur GitHub" renvoyant vers le dépôt du mini-projet]*
