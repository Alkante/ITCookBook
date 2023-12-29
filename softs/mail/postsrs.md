# About

PostSRSd provides the Sender Rewriting Scheme (SRS) via TCP-based lookup tables for Postfix. SRS is needed if your mail server acts as forwarder.
Sender Rewriting Scheme Crash Course

Imagine your server receives a mail from alice@example.com that is to be forwarded. 

If example.com uses the Sender Policy Framework to indicate that all legit mails originate from their server, your forwarded mail might be bounced, because you have no permission to send on behalf of example.com. 

The solution is that you map the address to your own domain, e.g. SRS0+xxxx=yy=example.com=alice@yourdomain.org (forward SRS). 

If the mail is bounced later and a notification arrives, you can extract the original address from the rewritten one (reverse SRS) and return the notification to the sender. 

You might notice that the reverse SRS can be abused to turn your server into an open relay. For this reason, xxxx and yy are a cryptographic signature and a time stamp.

If the signature does not match, the address is forged and the mail can be discarded.

# Install
```
cd /usr/local/src
wget https://github.com/roehling/postsrsd/archive/1.4.tar.gz -O postsrsd-1.4.tgz
tar -xzf postsrsd-1.4.tgz
cd postsrsd-1.4
apt-get install cmake
mkdir build
cd build
cmake ..
make
make install
```

# Config
```
sed -i 's/^#SRS_DOMAIN.*$/SRS_DOMAIN=mydomain.com/' /etc/default/postsrsd
```
PostSRSd écoute sur 10001 et 10002, il faut lier postfix avec :
```
grep canonical /etc/postfix/main.cf
sender_canonical_maps = tcp:127.0.0.1:10001
sender_canonical_classes = envelope_sender
recipient_canonical_maps = tcp:127.0.0.1:10002
recipient_canonical_classes= envelope_recipient,header_recipient
```
On recharge:
```
/etc/init.d/postsrsd restart
/etc/init.d/postfix restart
```
