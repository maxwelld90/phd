#!/bin/bash

# Rolls the prejudgement scripts for the experiments.
# Dumps everything to desktop.

mkdir /users/grad/david/Workspace/thesis/ch8/prerolled/out/

var="$(printf "%02d" $1)"
echo $var
echo "===="

# I1 Click
echo "I1 Click"
python die_roller.py trec2005.qrels 0.27 0.13 $1 512 > /users/grad/david/Workspace/thesis/ch8/prerolled/out/i1-$var-click.qrels
python die_roller_index.py /users/grad/david/Workspace/indexes/aquaint_whoosh 0.13 $1 512 >> /users/grad/david/Workspace/thesis/ch8/prerolled/out/i1-$var-click.qrels

# I1 Mark
echo "I1 Mark"
python die_roller.py trec2005.qrels 0.78 0.59 $1 512 > /users/grad/david/Workspace/thesis/ch8/prerolled/out/i1-$var-mark.qrels
python die_roller_index.py /users/grad/david/Workspace/indexes/aquaint_whoosh 0.59 $1 512 >> /users/grad/david/Workspace/thesis/ch8/prerolled/out/i1-$var-mark.qrels

# I2 Click
echo "I2 Click"
python die_roller.py trec2005.qrels 0.30 0.18 $1 512 > /users/grad/david/Workspace/thesis/ch8/prerolled/out/i2-$var-click.qrels
python die_roller_index.py /users/grad/david/Workspace/indexes/aquaint_whoosh 0.18 $1 512 >> /users/grad/david/Workspace/thesis/ch8/prerolled/out/i2-$var-click.qrels

# I2 Mark
echo "I2 Mark"
python die_roller.py trec2005.qrels 0.63 0.61 $1 512 > /users/grad/david/Workspace/thesis/ch8/prerolled/out/i2-$var-mark.qrels
python die_roller_index.py /users/grad/david/Workspace/indexes/aquaint_whoosh 0.61 $1 512 >> /users/grad/david/Workspace/thesis/ch8/prerolled/out/i2-$var-mark.qrels

# I3 Click
echo "I3 Click"
python die_roller.py trec2005.qrels 0.25 0.13 $1 512 > /users/grad/david/Workspace/thesis/ch8/prerolled/out/i3-$var-click.qrels
python die_roller_index.py /users/grad/david/Workspace/indexes/aquaint_whoosh 0.13 $1 512 >> /users/grad/david/Workspace/thesis/ch8/prerolled/out/i3-$var-click.qrels

# I3 Mark
echo "I3 Mark"
python die_roller.py trec2005.qrels 0.74 0.65 $1 512 > /users/grad/david/Workspace/thesis/ch8/prerolled/out/i3-$var-mark.qrels
python die_roller_index.py /users/grad/david/Workspace/indexes/aquaint_whoosh 0.65 $1 512 >> /users/grad/david/Workspace/thesis/ch8/prerolled/out/i3-$var-mark.qrels

# I4 Click
echo "I4 Click"
python die_roller.py trec2005.qrels 0.31 0.17 $1 512 > /users/grad/david/Workspace/thesis/ch8/prerolled/out/i4-$var-click.qrels
python die_roller_index.py /users/grad/david/Workspace/indexes/aquaint_whoosh 0.17 $1 512 >> /users/grad/david/Workspace/thesis/ch8/prerolled/out/i4-$var-click.qrels

# I4 Mark
echo "I4 Mark"
python die_roller.py trec2005.qrels 0.67 0.65 $1 512 > /users/grad/david/Workspace/thesis/ch8/prerolled/out/i4-$var-mark.qrels
python die_roller_index.py /users/grad/david/Workspace/indexes/aquaint_whoosh 0.65 $1 512 >> /users/grad/david/Workspace/thesis/ch8/prerolled/out/i4-$var-mark.qrels

echo
echo