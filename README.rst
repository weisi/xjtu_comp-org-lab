=========================
Computer Organization Lab
=========================

:Author:    Weisi Dai <weisi@x-research.com>
:Copyright: `CC BY-NC-SA 2.0 <http://creativecommons.org/licenses/by-nc-sa/2.0/>`_

This is the repository of my work associated with my Computer Organization Experiment course. All code in this repo is released under `GNU GPL v3`_, except those clearly tagged with other licenses. **Never use any piece of my code directly in your homework**.

.. _`GNU GPL v3`: https://www.gnu.org/copyleft/gpl.html

Tasks
-----

* 4 function modules
    * An arithmetic logic unit
    * 3-level sequential circuits
    * Instruction decoder
    * Memory
* A fundamental design of a computer system

Software
--------

The GNU toolchain is essential for compilation and automation.

VHDL Compiler: GHDL
~~~~~~~~~~~~~~~~~~~

I use GHDL_ as the compiler for VHDL which acts as a extension to GCC. I didn't find a 64-bit version of GHDL, so don't forget to install ``gcc-32bit``, ``zlib-32bit`` and ``zlib-devel-32bit`` on a 64-bit machine like the one I'm using.

.. _GHDL: http://ghdl.free.fr/

Waveform Viewer: Dinotrace and GTKWave
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

* Dinotrace_: traditional UI, better PDF output
* GTKWave_: seems more powerful

.. _Dinotrace: http://www.veripool.org/wiki/dinotrace
.. _GTKWave: http://gtkwave.sourceforge.net/
