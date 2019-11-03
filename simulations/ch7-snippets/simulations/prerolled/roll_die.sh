#!/bin/bash

# Rolls the prejudgement scripts for the experiments.
# Dumps everything to desktop.

mkdir /scratch2/david/thesis/ch7/prerolled/out/

var="$(printf "%02d" $1)"
echo $var
echo "===="

# T0 Click
echo "T0 Click"
python die_roller.py trec2005.qrels 0.28 0.18 $1 512 > /scratch2/david/thesis/ch7/prerolled/out/t0-$var-click.qrels
python die_roller_index.py /scratch2/david/indexes/aquaint_whoosh 0.18 $1 512 >> /scratch2/david/thesis/ch7/prerolled/out/t0-$var-click.qrels

# T0 Mark
echo "T0 Mark"
python die_roller.py trec2005.qrels 0.66 0.55 $1 512 > /scratch2/david/thesis/ch7/prerolled/out/t0-$var-mark.qrels
python die_roller_index.py /scratch2/david/indexes/aquaint_whoosh 0.55 $1 512 >> /scratch2/david/thesis/ch7/prerolled/out/t0-$var-mark.qrels

# T1 Click
echo "T1 Click"
python die_roller.py trec2005.qrels 0.34 0.23 $1 512 > /scratch2/david/thesis/ch7/prerolled/out/t1-$var-click.qrels
python die_roller_index.py /scratch2/david/indexes/aquaint_whoosh 0.23 $1 512 >> /scratch2/david/thesis/ch7/prerolled/out/t1-$var-click.qrels

# T1 Mark
echo "T1 Mark"
python die_roller.py trec2005.qrels 0.69 0.65 $1 512 > /scratch2/david/thesis/ch7/prerolled/out/t1-$var-mark.qrels
python die_roller_index.py /scratch2/david/indexes/aquaint_whoosh 0.65 $1 512 >> /scratch2/david/thesis/ch7/prerolled/out/t1-$var-mark.qrels

# T2 Click
echo "T2 Click"
python die_roller.py trec2005.qrels 0.35 0.25 $1 512 > /scratch2/david/thesis/ch7/prerolled/out/t2-$var-click.qrels
python die_roller_index.py /scratch2/david/indexes/aquaint_whoosh 0.25 $1 512 >> /scratch2/david/thesis/ch7/prerolled/out/t2-$var-click.qrels

# T2 Mark
echo "T2 Mark"
python die_roller.py trec2005.qrels 0.67 0.58 $1 512 > /scratch2/david/thesis/ch7/prerolled/out/t2-$var-mark.qrels
python die_roller_index.py /scratch2/david/indexes/aquaint_whoosh 0.58 $1 512 >> /scratch2/david/thesis/ch7/prerolled/out/t2-$var-mark.qrels

# T4 Click
echo "T4 Click"
python die_roller.py trec2005.qrels 0.4 0.24 $1 512 > /scratch2/david/thesis/ch7/prerolled/out/t4-$var-click.qrels
python die_roller_index.py /scratch2/david/indexes/aquaint_whoosh 0.24 $1 512 >> /scratch2/david/thesis/ch7/prerolled/out/t4-$var-click.qrels

# T4 Mark
echo "T4 Mark"
python die_roller.py trec2005.qrels 0.66 0.67 $1 512 > /scratch2/david/thesis/ch7/prerolled/out/t4-$var-mark.qrels
python die_roller_index.py /scratch2/david/indexes/aquaint_whoosh 0.67 $1 512 >> /scratch2/david/thesis/ch7/prerolled/out/t4-$var-mark.qrels

echo
echo