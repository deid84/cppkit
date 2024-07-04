#ifndef CLI_HPP_
#define CLI_HPP_

#include <string>
#include <vector>

using namespace std;

class Cli {
public:
  Cli(int argc, char* argv[]);
  bool versionRequested() const;
  void printVersion();
  
private:
  vector<string> arguments; 
  const string VERSION = "1.0.0";
};

#endif  // CLI_HPP_