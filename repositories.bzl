load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")
load("//:third_party_repositories.bzl", "jinja2", "markupsafe", "mistune", "org_golang_x_sys", "org_golang_x_tools", "zlib")

# WARNING: The following definitions are placeholders since none of the projects have been tested at the versions listed in this file.
# Please do not use them (yet). Future commits to this file will set the proper versions and ensure that all dependencies are correct.

def bazel():
    maybe(
        git_repository,
        name = "io_bazel",
        remote = "https://github.com/bazelbuild/bazel.git",
        commit = "c689bf93917ad0efa8100b3a0fe1b43f1f1a1cdf",  # Mar 19, 2019
    )

def bazel_buildtools_deps():
    bazel_skylib()
    rules_go()

def bazel_buildtools():
    bazel_buildtools_deps()
    maybe(
        http_archive,
        name = "com_github_bazelbuild_buildtools",
        strip_prefix = "buildtools-f27d1753c8b3210d9e87cdc9c45bc2739ae2c2db",
        url = "https://github.com/bazelbuild/buildtools/archive/f27d1753c8b3210d9e87cdc9c45bc2739ae2c2db.zip",
    )

def bazel_gazelle_deps():
    rules_go()
    # TODO(fweikert): add all gazelle dependencies to the federation

def bazel_gazelle():
    bazel_gazelle_deps()
    maybe(
        http_archive,
        name = "bazel_gazelle",
        sha256 = "7949fc6cc17b5b191103e97481cf8889217263acf52e00b560683413af204fcb",
        urls = ["https://github.com/bazelbuild/bazel-gazelle/releases/download/0.16.0/bazel-gazelle-0.16.0.tar.gz"],
    )

def bazel_integration_testing_deps():
    pass  # TODO(fweikert): examine dependencies and add them, if necessary

def bazel_integration_testing():
    bazel_integration_testing_deps()
    maybe(
        http_archive,
        name = "build_bazel_integration_testing",
        url = "https://github.com/bazelbuild/bazel-integration-testing/archive/13a7d5112aaae5572544c609f364d430962784b1.zip",
        type = "zip",
        strip_prefix = "bazel-integration-testing-13a7d5112aaae5572544c609f364d430962784b1",
        sha256 = "8028ceaad3613404254d6b337f50dc52c0fe77522d0db897f093dd982c6e63ee",
    )

def bazel_toolchains_deps():
    pass  # TODO(fweikert): examine dependencies and add them, if necessary

def bazel_toolchains():
    bazel_toolchains_deps()
    maybe(
        http_archive,
        name = "bazel_toolchains",
        sha256 = "5962fe677a43226c409316fcb321d668fc4b7fa97cb1f9ef45e7dc2676097b26",
        strip_prefix = "bazel-toolchains-be10bee3010494721f08a0fccd7f57411a1e773e",
        urls = [
            "https://mirror.bazel.build/github.com/bazelbuild/bazel-toolchains/archive/be10bee3010494721f08a0fccd7f57411a1e773e.tar.gz",
            "https://github.com/bazelbuild/bazel-toolchains/archive/be10bee3010494721f08a0fccd7f57411a1e773e.tar.gz",
        ],
    )

def bazel_skylib_deps():
    pass

def bazel_skylib():
    bazel_skylib_deps()
    maybe(
        http_archive,
        name = "bazel_skylib",
        urls = [
            "https://github.com/bazelbuild/bazel-skylib/releases/download/1.0.3/bazel-skylib-1.0.3.tar.gz",
            "https://mirror.bazel.build/github.com/bazelbuild/bazel-skylib/releases/download/1.0.3/bazel-skylib-1.0.3.tar.gz",
        ],
        sha256 = "1c531376ac7e5a180e0237938a2536de0c54d93f5c278634818e0efc952dd56c",
    )
    # TODO(aiuto): We should be able to call bazel_skylib_setup() here.
    #     That would register the toolchains. We can not because you can
    #     not do the load() here.
    # load("@bazel_federation//setup:bazel_skylib.bzl", "bazel_skylib_setup")
    # bazel_skylib_setup()

def bazel_stardoc_deps():
    bazel_skylib()
    rules_java()

def bazel_stardoc():
    bazel_stardoc_deps()
    maybe(
        http_archive,
        name = "io_bazel_skydoc",
        urls = [
            "https://mirror.bazel.build/github.com/bazelbuild/stardoc/archive/0.4.0.tar.gz",
            "https://github.com/bazelbuild/stardoc/archive/0.4.0.tar.gz",
        ],
        sha256 = "6d07d18c15abb0f6d393adbd6075cd661a2219faab56a9517741f0fc755f6f3c",
        strip_prefix = "stardoc-0.4.0",
    )

# TODO(fweikert): delete this function if it's not needed by the protobuf project itself.
def protobuf_deps():
    zlib()
    protobuf_javalite()

def protobuf():
    protobuf_deps()
    maybe(
        http_archive,
        name = "com_google_protobuf",
        sha256 = "b404fe166de66e9a5e6dab43dc637070f950cdba2a8a4c9ed9add354ed4f6525",
        strip_prefix = "protobuf-b4f193788c9f0f05d7e0879ea96cd738630e5d51",
        # Commit from 2019-05-15, update to protobuf 3.8 when available.
        url = "https://github.com/protocolbuffers/protobuf/archive/b4f193788c9f0f05d7e0879ea96cd738630e5d51.zip",
    )
    native.bind(name = "com_google_protobuf_cc", actual = "@com_google_protobuf")
    native.bind(name = "com_google_protobuf_java", actual = "@com_google_protobuf")

def protobuf_javalite_deps():
    pass

def protobuf_javalite():
    protobuf_javalite_deps()
    maybe(
        http_archive,
        name = "com_google_protobuf_javalite",
        strip_prefix = "protobuf-javalite",
        urls = ["https://github.com/protocolbuffers/protobuf/archive/javalite.zip"],
    )

def rules_cc_deps():
    bazel_skylib()

def rules_cc():
    rules_cc_deps()
    maybe(
        http_archive,
        name = "rules_cc",
        url = "https://github.com/bazelbuild/rules_cc/archive/624b5d59dfb45672d4239422fa1e3de1822ee110.zip",
        sha256 = "8c7e8bf24a2bf515713445199a677ee2336e1c487fa1da41037c6026de04bbc3",
        strip_prefix = "rules_cc-624b5d59dfb45672d4239422fa1e3de1822ee110",
        type = "zip",
    )

def rules_go_deps():
    bazel_skylib()

def rules_go():
    rules_go_deps()
    maybe(
        http_archive,
        name = "io_bazel_rules_go",
        urls = [
            "https://github.com/bazelbuild/rules_go/archive/0c1081b3618a2c6ca1220f7f7ffb644a2955ddf8.zip"
        ],
        sha256 = "3cb1bf7f2a3bbd9bed618234a792ce522093138a6298d6d4688b7b8018a49f8b",
        strip_prefix = "rules_go-0c1081b3618a2c6ca1220f7f7ffb644a2955ddf8",
    )

def rules_java_deps():
    # TODO(aiuto): When rules_java stabalizes, reference the deps directly.
    # rules_java is going to be changing for the next few months. While that
    # is happening we let rules_java_setup() bring in the deps. This allows
    # use to quicky update rules_java without havig to update all of the deps
    # tree which is only used by Java.
    bazel_skylib()

def rules_java():
    rules_java_deps()
    maybe(
        http_archive,
        name = "rules_java",
        urls = [
            "https://mirror.bazel.build/github.com/bazelbuild/rules_java/archive/rules_java-0.1.1.tar.gz",
            "https://github.com/bazelbuild/rules_java/releases/download/0.1.1/rules_java-0.1.1.tar.gz",
        ],
        sha256 = "220b87d8cfabd22d1c6d8e3cdb4249abd4c93dcc152e0667db061fb1b957ee68",
    )

def rules_nodejs_deps():
    pass

def rules_nodejs():
    rules_nodejs_deps()
    maybe(
        http_archive,
        name = "build_bazel_rules_nodejs",
        url = "https://github.com/bazelbuild/rules_nodejs/releases/download/0.30.1/rules_nodejs-0.30.1.tar.gz",
        sha256 = "abcf497e89cfc1d09132adfcd8c07526d026e162ae2cb681dcb896046417ce91",
    )

def rules_pkg_deps():
    pass

def rules_pkg():
    rules_pkg_deps()
    maybe(
        http_archive,
        name = "rules_pkg",
        urls = [
            "https://mirror.bazel.build/github.com/bazelbuild/rules_pkg/releases/download/0.2.4/rules_pkg-0.2.4.tar.gz",
            "https://github.com/bazelbuild/rules_pkg/releases/download/0.2.4/rules_pkg-0.2.4.tar.gz",
        ],
        sha256 = "4ba8f4ab0ff85f2484287ab06c0d871dcb31cc54d439457d28fd4ae14b18450a",
    )

def rules_python_deps():
    pass

def rules_python():
    rules_python_deps()
    maybe(
        http_archive,
        name = "rules_python",
        strip_prefix = "rules_python-cd552725122fdfe06a72864e21a92b5093a1857d",
        type = "zip",
        url = "https://github.com/bazelbuild/rules_python/archive/cd552725122fdfe06a72864e21a92b5093a1857d.zip",
        sha256 = "e4ddb2bf3c2e0ddfec5a1ab41e480661e65605c6e3c336fe85c5bd6a267dbc2e",
    )

def rules_rust_deps():
    bazel_skylib()

def rules_rust():
    rules_rust_deps()
    maybe(
        http_archive,
        name = "io_bazel_rules_rust",
        strip_prefix = "rules_rust-55f77017a7f5b08e525ebeab6e11d8896a4499d2",
        url = "https://github.com/bazelbuild/rules_rust/archive/55f77017a7f5b08e525ebeab6e11d8896a4499d2.tar.gz",
        sha256 = "b6da34e057a31b8a85e343c732de4af92a762f804fc36b0baa6c001423a70ebc",
    )

def rules_sass_deps():
    bazel_skylib()
    rules_nodejs()

def rules_sass():
    rules_sass_deps()
    maybe(
        git_repository,
        name = "io_bazel_rules_sass",
        remote = "https://github.com/bazelbuild/rules_sass.git",
        commit = "8ccf4f1c351928b55d5dddf3672e3667f6978d60",
    )

def rules_scala_deps():
    bazel_skylib()

def rules_scala():
    rules_scala_deps()
    maybe(
        http_archive,
        name = "io_bazel_rules_scala",
        strip_prefix = "rules_scala-300b4369a0a56d9e590d9fea8a73c3913d758e12",
        type = "zip",
        # commit from 2019-05-27
        url = "https://github.com/bazelbuild/rules_scala/archive/300b4369a0a56d9e590d9fea8a73c3913d758e12.zip",
        sha256 = "7f35ee7d96b22f6139b81da3a8ba5fb816e1803ed097f7295b85b7a56e4401c7",
    )
