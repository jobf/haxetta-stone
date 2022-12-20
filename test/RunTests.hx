package test;

import utest.Runner;

import utest.ui.Report;

class RunTests {
	public static function main() {
		 var runner = new Runner();
		 runner.addCase(new EditorTests());
		 runner.addCase(new VectorTests());
		 Report.create(runner);
		 runner.run();
	  }
}