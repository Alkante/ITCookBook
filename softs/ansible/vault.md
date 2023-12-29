# Vault

## Contexte
Ansible Vault permet de chiffrer en AES:
 - des fichiers
 - des variables dans un yml

Pour chiffrer, Vault a besoin d'un mot de passe.

Pour des raison d'automatisation, les mots de passe sont toujours assossier un nom (un vault-id) pour savoir le quel c'est.

## Liens
Source:
 - https://docs.ansible.com/ansible/latest/cli/ansible-vault.html#ansible-vault
 - https://docs.ansible.com/ansible/latest/user_guide/vault.html#what-can-be-encrypted-with-vault

## Avec un fichier
| Command | Description |
|- |- |
| ```ansible-vault create --vault-id password1@prompt foo.yml``` | Création d'un fichier **foo.yml** avec un nom (vault id) de clef  **password1** et un password demandé à la volé (prompt) |
| ```ansible-vault edit foo.yml``` | Edite le fichier chiffré **foo.yml**. Cette commande demande le password qui à pour nom (vault id) **password1** |
| ```ansible-vault edit --vault-id pass2@vault2 foo.yml``` | Edite le fichier chiffré **foo.yml**. Cette commande utiliser le password nommé **pass2** disponible dans le fichier **./vault2** |


## Fichier de password

```bash
echo 'the_password' > .vault
echo '/.vault' >> .gitignore
ansible-vault edit --vault-id pass2@vault foo.yml
```


Multi password Vault
```bash
ansible-vault edit  --vault-id pass2@vaul2 --vault-id pass3@vault3 --vault-id pass4@vaul4 foo.yml
```