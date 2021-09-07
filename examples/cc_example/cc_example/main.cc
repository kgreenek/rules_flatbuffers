#include <iostream>

#include "flatbuffers/flatbuffers.h"
#include "flatbuffers/minireflect.h"
#include "geom_fbs/quaternion_generated.h"
#include "geom_fbs/vector_generated.h"
#include "viz_fbs/marker_generated.h"

int main(int argc, char** argv) {
  flatbuffers::FlatBufferBuilder builder;
  auto position = geom_fbs::Vector3f{0.0, 0.0, 0.0};
  auto rotation = geom_fbs::Quaternionf{0.0, 0.0, 0.0, 1.0};
  auto pose = geom_fbs::Isometry3f(position, rotation);
  auto marker = viz_fbs::CreateMarker(builder, &pose);
  builder.Finish(marker);
  std::cout << flatbuffers::FlatBufferToString(builder.GetBufferPointer(),
                                               viz_fbs::MarkerTypeTable())
            << std::endl;
  return 0;
}
