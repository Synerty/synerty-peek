import os
import shutil

from setuptools import find_packages, setup

pip_package_name = "synerty-peek"
package_version = "0.0.0"

egg_info = "%s.egg-info" % pip_package_name
if os.path.isdir(egg_info):
    shutil.rmtree(egg_info)

if os.path.isfile("MANIFEST"):
    os.remove("MANIFEST")

platformPackages = [
    "peek-admin-doc",
    "peek-admin-app",
    "peek-agent-service",
    "peek-core-device",
    "peek-core-docdb",
    "peek-core-email",
    "peek-core-search",
    "peek-core-user",
    "peek-core-screen",
    "peek-field-doc",
    "peek-field-app",
    "peek-field-service",
    "peek-logic-service",
    "peek-office-doc",
    "peek-office-app",
    "peek-office-service",
    "peek-platform",
    "peek-plugin-base",
    "peek-storage-service",
    "peek-worker-service",
]

abstractPackages = [
    "peek-abstract-chunked-index",
    "peek-abstract-chunked-data-loader",
]

requirements = platformPackages + abstractPackages

# Force the dependencies to be the same branch
reqVer = ".".join(package_version.split(".")[0:2]) + ".*"

# >=2.0.*,>=2.0.6
requirements = [
    "%s==%s,>=%s" % (pkg, reqVer, package_version) for pkg in requirements
]

doc_requirements = [
    "sphinx",
    "sphinx-rtd-theme",
    "sphinx-autobuild",
    "pytmpdir>=1.0.2",
]

requirements.extend(doc_requirements)

debug_requirements = ["py-spy"]

requirements.extend(debug_requirements)

setup(
    name=pip_package_name,
    packages=find_packages(
        exclude=["*.tests", "*.tests.*", "tests.*", "tests"]
    ),
    install_requires=requirements,
    zip_safe=False,
    version=package_version,
    description="Peek Platform - Meta Package to install all services",
    author="Synerty",
    author_email="contact@synerty.com",
    url="https://gitlab.synerty.com/peek/community/%s" % pip_package_name,
    download_url="https://gitlab.synerty.com/peek/community/%s/tarball/%s"
    % (pip_package_name, package_version),
    keywords=["Peek", "Python", "Platform", "synerty"],
    classifiers=["Programming Language :: Python :: 3.5"],
)
