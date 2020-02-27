# webservco/internet-latency-test

Test internet latency using the ping command and write the results in a CSV file.

---

## Usage


```sh
# create and edit the configuration file
cp config.sh.dist config.sh && vim config.sh
# make executable
chmod +x internet-latency-test.sh
# run manually
. internet-latency-test.sh
```

### Cron example

```sh
# run every minute
* * * * * {PATH}internet-latency-test.sh
```

---
