# Empêcher Firefox de faire une recherche une recherche par défaut pour un nom de domaine avec un TLD personnalisé

Exemple : pour le nom serveur.entreprise.tldperso, Firefox peut considérer que ce n'est pas un nom de domaine "valide" alors qu'il est résolvable en interne, et peut déclencher une recherche au lieu de tenter une résolution DNS.
Le problème n'est pas présent pour certains TLD (.example, .local, .localhost, .invalid ...) car ils sont déjà en whitelist.


Pour ajouter des TLD en whitelist aller dans about:config et ajouter un item :

**browser.fixup.domainsuffixwhitelist.tldperso** de type **booléen** avec la valeur **true**

Source : https://support.mozilla.org/en-US/questions/1292986
