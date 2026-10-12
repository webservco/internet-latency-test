# webservco/internet-latency-test

A Bash script.

Pings a host for a set number of seconds and appends the packet loss and round-trip times to a daily CSV file.

- Requires: Bash, `ping` (iputils), GNU `grep` with `-P`
- Related: `webservco/internet-bandwidth-test` (the same for download and upload speed)

---

## Installation

```shell
git clone https://github.com/webservco/internet-latency-test.git
cd internet-latency-test
cp config.sh.dist config.sh
```

---

## Usage

```shell
# Run once.
. internet-latency-test.sh
```

Each run appends one line to `{log_path}{YYYY-MM}/{log_name}-{YYYY-MM-DD}.csv`, creating the directory and the file if needed.

```text
Date,Transmitted,Received,Errors,Loss,Time,Min,Avg,Max,Mdev,Message
2021-02-09T10:00:01,10,10,,0,9013,12.1,13.4,17.9,1.6,""
```

Loss is a percentage. Time is the total run time and the other times are the round-trip times, all in ms. Errors is empty when `ping` reports none.

### Cron

```shell
# Every minute.
* * * * * /path/to/internet-latency-test/internet-latency-test.sh
```

---

## Configuration

Keys read from `config.sh`:

```shell
# Full path to the log directory, with trailing slash.
log_path='/full/path/'
log_name='internet-latency-test'
ping_host='google.com'
# How long to ping, in seconds.
ping_time='10'
# 1: also write the full ping output in the Message column.
debug=1
```

---

## Notes

The full output is always written when `ping` fails to run, even with `debug=0`.

Keep `ping_time` well under the cron interval, so runs don't overlap.

---

## License

[MIT](LICENSE)
