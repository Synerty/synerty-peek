from twisted.internet import defer, reactor
from twisted.web.client import Agent, Headers

maxRun = 2

urls = [
    b"https://ftp.gnu.org/gnu/gcc/gcc-10.2.0/gcc-10.2.0.tar.gz",
    b"https://ftp.gnu.org/gnu/gcc/gcc-10.1.0/gcc-10.1.0.tar.gz",
    b"https://ftp.gnu.org/gnu/gcc/gcc-9.3.0/gcc-9.3.0.tar.gz",
    b"https://ftp.gnu.org/gnu/gcc/gcc-8.1.0/gcc-8.1.0.tar.gz",
    b"https://ftp.gnu.org/gnu/gcc/gcc-7.1.0/gcc-7.1.0.tar.gz",
    b"https://ftp.gnu.org/gnu/gcc/gcc-5.4.0/gcc-5.4.0.tar.gz",
    b"https://ftp.gnu.org/gnu/gcc/gcc-4.8.0/gcc-4.8.0.tar.gz",
]


def listCallback(results):
    for isSuccess, response in results:
        print(
            response.request.absoluteURI.decode("utf-8"),
            f"{round(response.length / 1024 / 1024, 2)} MB",
        )


def request_url(url):
    agent = Agent(reactor)
    d = agent.request(b"GET", url)
    return d


def finish(ign):
    reactor.stop()


def download():
    #
    # your code starts HERE
    #
    #
    # your code ends HERE
    #
    dl = defer.DeferredList(deferreds)
    dl.addCallback(listCallback)
    dl.addCallback(finish)


if __name__ == "__main__":
    download()
    reactor.run()
