import os
import shutil

from setuptools import find_packages, setup

pip_package_name = "synerty-peek"
package_version = '0.0.0'

egg_info = "%s.egg-info" % pip_package_name
if os.path.isdir(egg_info):
    shutil.rmtree(egg_info)

if os.path.isfile('MANIFEST'):
    os.remove('MANIFEST')

platformPackages = [
    "peek-plugin-base",
    "peek-platform",
    "peek-agent-service",
    "peek-office-app",
    "peek-worker-service",
    "peek-field-app",
    "peek-office-service",
    "peek-doc-user",
    "peek-admin-app",
    "peek-doc-admin",
    "peek-doc-dev",
    "peek-logic-service",
    "peek-storage-service",
    "peek-core-email",
    "peek-core-device",
    "peek-core-user",
    "peek-core-search"
]

abstractPackages = [
    "peek-abstract-chunked-index",
    "peek-abstract-chunked-data-loader"
]

requirements = platformPackages + abstractPackages

# Force the dependencies to be the same branch
reqVer = '.'.join(package_version.split('.')[0:2]) + ".*"

# >=2.0.*,>=2.0.6
requirements = ["%s==%s,>=%s" % (pkg, reqVer, package_version) for pkg in requirements]

doc_requirements = [
    "sphinx",
    "sphinx-rtd-theme",
    "sphinx-autobuild",
    "pytmpdir"
]

requirements.extend(doc_requirements)

setup(
    name=pip_package_name,
    packages=find_packages(exclude=["*.tests", "*.tests.*", "tests.*", "tests"]),
    install_requires=requirements,
    zip_safe=False, version=package_version,
    description='Peek Platform - Meta Package to install all services',
    author='Synerty',
    author_email='contact@synerty.com',
    url='https://github.com/Synerty/%s' % pip_package_name,
    download_url='https://github.com/Synerty/%s/tarball/%s' % (
        pip_package_name, package_version),
    keywords=['Peek', 'Python', 'Platform', 'synerty'],
    classifiers=[
        "Programming Language :: Python :: 3.5",
    ],
)
