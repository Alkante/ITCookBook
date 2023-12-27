#!/bin/sh
### Affichage de toutes les TABLES/CHAINS/RULES IPTABLES ###

# Display raw chains
echo "######################## RAW ##############################"
iptables  -t raw -nvL

# Display mangle chains
echo "######################## MANGLE ###########################"
iptables -t mangle -nvL

# Display nat chains
echo "######################## NAT ##############################"
iptables -t nat -nvL

# Display filter chains
echo "######################## FILTER ###########################"
iptables -t filter -nvL
# Or
#iptables -nVL


