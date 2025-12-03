const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    // Read input file
    const file = try std.fs.cwd().openFile("inputs/day01.txt", .{});
    defer file.close();

    const input = try file.readToEndAlloc(allocator, 1024 * 1024);
    defer allocator.free(input);

    // Part 1
    const part1_result = try solvePart1(allocator, input);
    std.debug.print("Part 1: {d}\n", .{part1_result});
}

fn solvePart1(allocator: std.mem.Allocator, input: []const u8) !i64 {
    _ = allocator;

    var zero_count: i64 = 0;
    var curr_position: i16 = 50;
    var curr_change: i16 = 0;

    var lines = std.mem.splitScalar(u8, input, '\n');
    while (lines.next()) |line| {
        if (line.len == 0) continue; // skip empty lines

        // std.debug.print("curr_position: {d}\n", .{curr_position});
        if (line[0] == 'L') {
            curr_change = try std.fmt.parseInt(i16, line[1..], 10);
            curr_position = @mod(curr_position - curr_change + 100, 100);

        } else if (line[0] == 'R') {
            curr_change = try std.fmt.parseInt(i16, line[1..], 10);
            curr_position = @mod(curr_position + curr_change + 100, 100);
        }

        if (curr_position == 0) {
            zero_count += 1;
            // std.debug.print("zero_count: {d}\n", .{zero_count});
        }
        // reset curr_change value during each loop
        curr_change = 0;
    }

    return zero_count;
}
