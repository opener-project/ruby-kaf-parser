##
# Reads the fixture file and returns its contents.
#
# @param [String] path The path relative to the fixture directory.
# @return [String]
#
def fixture(path)
  path = File.join(File.expand_path('../../fixtures', __FILE__), path)

  return File.read(path)
end
