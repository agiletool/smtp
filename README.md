docker-postfix
==============

run postfix with smtp authentication (sasldb) in a docker container.
TLS and OpenDKIM support are optional.

## Requirement
+ Docker 1.0

## Installation
1. Build image

	```bash
	$ sudo docker pull catatnight/postfix
	```

## Usage
1. Create postfix container with smtp authentication

	```bash
	$ sudo docker run -p 25:25 \
			-e maildomain=mail.example.com -e smtp_user=user:pwd \
			--name postfix -d catatnight/postfix
	# Set multiple user credentials: -e smtp_user=user1:pwd1,user2:pwd2,...,userN:pwdN
	```
2. Enable OpenDKIM: save your domain key ```.private``` in ```/path/to/domainkeys```

	```bash
	$ sudo docker run -p 25:25 \
			-e maildomain=mail.example.com -e smtp_user=user:pwd \
			-v /path/to/domainkeys:/etc/opendkim/domainkeys \
			--name postfix -d catatnight/postfix
	```

	Create private key:
	```bash
	$ sudo docker exec -i postfix opendkim-genkey -s mail -d mozzuu.store
	$ sudo docker cp postfix:/mail.private /path/to/domainkeys/mail.private
	```
	Add public key to DNS
	```bash
	$ sudo docker exec -i postfix cat mail.txt
	```
	```
	mail._domainkey IN      TXT     ( "v=DKIM1; k=rsa; "  "p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDk/yE9oKlsnrq2/m9XaydqmDUGQNLoOls6+Tf3Hz3nglBQ42IldJxhN4eBMk2qUJRUNjjAxUshR/hSZ1pXMBWRtI9iP2mJy4kEarbgZrxr0w3NYDNddxi6IAIw0VnjI6TKpxhTYVVhwfLm2MubmPYEB+qFVI7q2JWMPVO1uEXN6QIDAQAB" )  ; ----- DKIM key mail for mozzuu.store
	```
	Copy that key and add a TXT record to your domain's DNS entries:
	```
	Name: mail._domainkey.mozzuu.store.
	Text: "v=DKIM1; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDk/yE9oKlsnrq2/m9XaydqmDUGQNLoOls6+Tf3Hz3nglBQ42IldJxhN4eBMk2qUJRUNjjAxUshR/hSZ1pXMBWRtI9iP2mJy4kEarbgZrxr0w3NYDNddxi6IAIw0VnjI6TKpxhTYVVhwfLm2MubmPYEB+qFVI7q2JWMPVO1uEXN6QIDAQAB"
	```

	
3. Enable TLS(587): save your SSL certificates ```.key``` and ```.crt``` to  ```/path/to/certs```

	```bash
	$ sudo docker run -p 587:587 \
			-e maildomain=mail.example.com -e smtp_user=user:pwd \
			-v /path/to/certs:/etc/postfix/certs \
			--name postfix -d catatnight/postfix
	```

## Note
+ Login credential should be set to (`username@mail.example.com`, `password`) in Smtp Client
+ You can assign the port of MTA on the host machine to one other than 25 ([postfix how-to](http://www.postfix.org/MULTI_INSTANCE_README.html))
+ Read the reference below to find out how to generate domain keys and add public key to the domain's DNS records

## Reference
+ [Postfix SASL Howto](http://www.postfix.org/SASL_README.html)
+ [How To Install and Configure DKIM with Postfix on Debian Wheezy](https://www.digitalocean.com/community/articles/how-to-install-and-configure-dkim-with-postfix-on-debian-wheezy)
+ TBD
