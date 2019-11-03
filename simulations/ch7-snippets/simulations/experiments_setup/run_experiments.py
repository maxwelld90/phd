import os
import sys
import time
import subprocess
from time import sleep

def update_processes(processes_list):
    """
    Checks to see each process in the list provided is running.
    If a process is not, then it is removed from the new list which is returned.
    """
    updated_list = []
    
    for process in processes_list:
        process.poll()
        
        if process.returncode is None:
            updated_list.append(process)
    
    return updated_list

def run_simulations(simulation_root_dir, concurrent_processes, stdout_filename, stderr_filename, simulation_list):
    """
    Runs the simulations based on the list provided.
    Once complete, this function terminates the process.
    """
    os.chdir(simulation_root_dir)
    
    commands = simulation_list
    active_processes = []
    max_concurrent = int(concurrent_processes)
    commands_position = 0
    sleep_for = 1

    stdout_file = open(stdout_filename, 'w')
    stderr_file = open(stderr_filename, 'w')

    print "{0}: Ready to start".format(time.strftime("%c"))

    while True:
        active_processes = update_processes(active_processes)
        
        if len(active_processes) == max_concurrent:
            sleep(sleep_for)
            continue

        if commands_position == len(commands):
            break

        print "{0}: Starting process {1}".format(time.strftime("%c"), commands[commands_position])
        pid = subprocess.Popen(['python', 'run_simiir.py', commands[commands_position]], stdout=stdout_file, stderr=stderr_file)
        
        active_processes.append(pid)

        commands_position += 1
        sleep(sleep_for)

    stdout_file.close()
    stderr_file.close()
    
    print "{0}: Complete".format(time.strftime("%c"))

def get_simulation_run_list(commands_filename):
    """
    Given the path to the commands filename, returns a list of simulations to run.
    """
    f = open(commands_filename, 'r')
    simulations = []
    
    for line in f:
        line = line.strip()
        simulations.append(line)
        
    f.close()
    return simulations

def usage(script_name):
    """
    Prints the usage for this script, and terminates.
    """
    print "Usage:"
    print "    {0} <simulation_root_dir> <commands_file> <stdout_file> <stderr_file> <max_concurrent_processes>".format(script_name)
    print "Where:"
    print "    <simulation_root_dir> Path to the root directory for the simulator"
    print "    <commands_file> Path to the list of simulations to be run (pointing to simulation XML configuration files)"
    print "    <stdout_file> Path to the file for which stdout output will be stored"
    print "    <stderr_file> Path to the file for which stderr output will be stored"
    print "    <max_concurrent_processes> Maximum number of processes that can simultaneously run"
    sys.exit(1)

if __name__ == '__main__':
    if len(sys.argv) != 6:
        usage(sys.argv[0])
    
    simulation_root_dir = sys.argv[1]
    commands_filename = sys.argv[2]
    stdout_filename = sys.argv[3]
    stderr_filename = sys.argv[4]
    concurrent_processes = sys.argv[5]
    
    simulations = get_simulation_run_list(commands_filename)
    run_simulations(simulation_root_dir, concurrent_processes, stdout_filename, stderr_filename, simulations)