.. _setup_os_requirements_rhel8:

============================
Setup OS Requirements RHEL 8
============================


Please follow the :ref:`setup_os_requirements_rhel7` **except for updates in
Section Starting off and Section Partition Table.**


Staring Off
~~~~~~~~~~~

#3 Goto the **INSTALLATION DESTINATION** screen

The following partitioning is recommended for DEV peek virtual machines.

Select: ::

    Custom

.. image:: rhel8_installation_destination.png

Select **Done**.

Partition Table
~~~~~~~~~~~~~~~

We'll be creating partitions, `/boot`, `/`, `swap`, `/var`, `/usr`, `/tmp` and
`/home`, with one virtual logical volume per mount point.

Having one virtual logical volume per mount point allows VM
software to easily expand the disk and filesystem as required.

----

Select **LVM**

Again, This is to allow the virtual machine software to expand the DEV server
disks more easily.

.. image:: rhel8_lvm.png

----

Add the partitions, for each partition, click the plus.

.. image:: rhel8_new_partition.png

----

Set the Mount Point to **/boot**

Set the size to **1g**

Click **Add mount point**

.. image:: rhel8_new_mount_boot.png

----

Set the Mount Point to **swap**

Set the size to **10g**

Click **Add mount point**

.. image:: rhel8_new_mount_swap.png

----

Set the Mount Point to **/**

Set the size to **5g**

Click **Add mount point**

.. image:: rhel8_new_mount_root.png

----

Set the Mount Point to **/tmp**

Set the size to **5g**

Click **Add mount point**

.. image:: rhel8_new_mount_tmp.png

----

Set the Mount Point to **/usr**

Set the size to **5g**

Click **Add mount point**

.. image:: rhel8_new_mount_usr.png

----

Set the Mount Point to **/var**

Set the size to **5g**

Click **Add mount point**

.. image:: rhel8_new_mount_var.png

----

Set the Mount Point to **/home**

Set the size to **10g**

Click **Add mount point**

.. image:: rhel8_new_mount_home.png

----

And finally, go to any mount point and click 'Modify' to rename Volume Group.

.. image:: rhel8_rename_vg_step1.png

Rename it as `rootvg`

.. image:: rhel8_rename_vg_step2.png

Click **Save**

----

You should have a partition layout as follows, Click **Done**

.. image:: rhel8_example_partition.png

----

Click **Accept Changes**


.. image:: rhel8_confrm_partition.png



What Next?
----------

Refer back to the :ref:`how_to_use_peek_documentation` guide to see which document to
follow next.
