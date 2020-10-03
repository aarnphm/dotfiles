Pointer in C
------------

- memory is organised as a *sequence of bytes*
- each byte has an *address* 
- 0x01, 0x02

- its value will be stored at the location of the memory address
- b will share same address with ``&b[0]``

Address Operator
++++++++++++++++

- refer to this memory address using ``&var``
- cannot use address operator with a constant or *const*

Indirection Operator
++++++++++++++++++++

.. code-block:: c

   int *nPtr;
   int n=9;
   nPtr = &n;
   *nPtr = 20;

- **n = *nPtr**
- **&n = nPtr**

What does name of an array represents?
++++++++++++++++++++++++++++++++++++++

- name of an array represents the address of the array, or the *address of its first elements*
- ``b + 3*entry size``

- C allows to refer outside the array boundaries

Pointer
-------

- **Memory addresses**

- is a new kind of data type
- type of operation that can be done on the variable
- values of this value that can take
- storage or represents in the memory

- value of pointer variable is the memory address of another variable
- can hold/refer different type (int*)

.. image:: ./pointers.png
