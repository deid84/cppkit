#include <iostream>
#include <string>
#include <vector>
#include "cppkit/version.hpp"


/**
 * @brief Entry point of the application.
 *
 * This is the main function of the application. It prints the welcome message
 * along with the version of cppkit and then lists all the command line 
 * arguments provided to the application.
 *
 * @param argc The number of command line arguments.
 * @param argv An array of C-style strings representing the command line arguments.
 * @return int Returns 0 on successful execution.
 */
int main(int argc, char* argv[]){
    std::vector<std::string> args(argv, argv + argc);

    std::cout << "welcome to cppkit: " << CPPKIT_VERSION << std::endl;
    std::cout << "----------" << std::endl;
 
    for (const std::string &arg : args) {
        std::cout << arg << std::endl;    
    } 
}
