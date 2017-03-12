using ConstructiveSolidGeometry
# start with track at known angle
# straight up, normalized
p = (1,1,0)
# momentum = sqrt(2) GeV


# make the bar
dX = 10
dY = 50
dZ = 120
top =   Plane(Coord(dX, 0.0, 0.0),  unitize(Coord(1.0, 0.0, 0.0)),  "reflective")
bot =   Plane(Coord(-dX, 0.0, 0.0), unitize(Coord(-1.0, 0.0, 0.0)), "reflective")
front = Plane(Coord(0.0, dY, 0.0),  unitize(Coord(0.0, 1.0, 0.0)),  "reflective")
back =  Plane(Coord(0.0, -dY, 0.0), unitize(Coord(0.0, -1.0, 0.0)), "reflective")
right = Plane(Coord(0.0, 0.0, dZ),  unitize(Coord(0.0, 0.0, 1.0)),  "reflective")
# PMT readout is defined to be on the left side
left =  Plane(Coord(0.0, 0.0, -dZ), unitize(Coord(0.0, 0.0, -1.0)), "transmission")

# define the geometry
cells = Array{Cell}(0)
regions = Array{Region}(0)

# the normals point outwards, so the -1 means that we're interested in the
# half-region that points away from the normal, i.e. the inside of the plane
push!(regions, Region(top, -1))
push!(regions, Region(bot, -1))
push!(regions, Region(left, -1))
push!(regions, Region(right, -1))
push!(regions, Region(front, -1))
push!(regions, Region(back, -1))
ex = :(1 ^ 2 ^ 3 ^ 4 ^ 5 ^ 6)
push!(cells, Cell(regions, ex))

# let's plot the box
bounding_box = Box(Coord(-dX, -dY, -dZ), Coord(dX, dY, dZ))
geometry = Geometry(cells, bounding_box)
#plot_cell_2D(geometry, Box(Coord(-dX, -dY, 0), Coord(dX, dY, 0)), 1000, 2)

for x in 1:10000
    ray = generate_random_ray(geometry.bounding_box)
    # Perform a single step of ray tracing on the geometry
    new_ray, id, boundary_type = find_intersection(ray, geometry)
    # Compute distance travelled by the ray
    distance = magnitude( new_ray.origin - ray.origin )
    while boundary_type != "transmission"
        distance += magnitude( new_ray.origin - ray.origin )
        new_ray, id, boundary_type = find_intersection(new_ray, geometry)
    end
    println("Ray moved ", distance, " [cm] before hitting a ", boundary_type, " boundary")
end
