#===============================================================================
#
#   Sample external MethodScript include
#
#===============================================================================

/**
 * Returns the distance between two blocks, or any other 3d points, for that matter.
 * @param array @arr1 The first point, expects an array of x, y, z
 * @param array @arr2 The second point, expects an array of x, y, z
 */
proc(_3d_distance, @arr1, @arr2,
    return(
        floor(
            sqrt(				
                  ((@arr2[0] - @arr1[0]) ** 2)
				+ ((@arr2[1] - @arr1[1]) ** 2)
				+ ((@arr2[2] - @arr1[2]) ** 2)
            )
        )
    )
)

/**
 * Given two blocks, iterates through all the blocks inside the cuboid, and calls the 
 * user defined function on them. The used defined procedure should accept 3 parameters,
 * the x, y, and z coordinates of the block.
 */
proc(_iterate_cuboid, @b1, @b2, @proc_name,
        for(assign(@x, min(@b1[0], @b2[0])), @x <= max(@b1[0], @b2[0]), @x++,
                for(assign(@y, min(@b1[1], @b2[1])), @y <= max(@b1[1], @b2[1]), @y++,
                        for(assign(@z, min(@b1[2], @b2[2])), @z <= max(@b1[2], @b2[2]), @z++,
                                call_proc(@proc_name, @x, @y, @z)
                        )
                )
        )
)
