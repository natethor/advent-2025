const std = @import("std");

const Result = struct {
    part1: i64,
    part2: i64,
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    // Read input file
    const file = try std.fs.cwd().openFile("inputs/day01.txt", .{});
    defer file.close();

    const input = try file.readToEndAlloc(allocator, 1024 * 1024);
    defer allocator.free(input);

    const results = try solveParts(input);

    std.debug.print("Part 1: {d}\n", .{results.part1});
    std.debug.print("Part 2: {d}\n", .{results.part2});
}

fn solveParts(input: []const u8) !Result {
    var zero_count: i64 = 0;
    var loop_count: i64 = 0;
    var curr_position: i16 = 50;
    var curr_increment: i16 = 0;
    var loops: i64 = 0;

    var lines = std.mem.splitScalar(u8, input, '\n');
    while (lines.next()) |line| {
        if (line.len == 0) continue; // skip empty lines

        curr_increment = try std.fmt.parseInt(i16, line[1..], 10);
        const old_position = curr_position;

        if (line[0] == 'L') {
            const delta = curr_position - curr_increment;
            curr_position = @mod(delta, 100);
            loops = @divFloor(delta, 100);

            // when starting at 0, we overcount by 1
            if (old_position == 0 and loops != 0) {
                loops += 1;
            }

            // when delta is exactly divisible by 100, we land on 0 and undercount by 1
            // thanks reddit for helping with this edge case
            if (delta < 0 and @mod(delta, 100) == 0) {
                loops -= 1; // -1 becomes -2, so abs is larger
            }
        } else if (line[0] == 'R') {
            const delta = curr_position + curr_increment;
            curr_position = @mod(delta, 100);
            loops = @divFloor(delta, 100);
        }

        if (curr_position == 0) {
            zero_count += 1;
        }

        if (curr_position == 0 and loops == 0) {
            loop_count += 1;
        } else {
            loop_count = loop_count + @as(i64, @intCast(@abs(loops)));
        }
    }

    return Result{ .part1 = zero_count, .part2 = loop_count };
}
