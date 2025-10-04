import datetime;

walker DayOfWeek {
    can start with `root entry;
}

impl DayOfWeek.start {
    print("Enter a date (YYYY-MM-DD):");
    date_str = input();
    # Basic validation
    parts = date_str.split("-");
    if len(parts) != 3 {
        print("Invalid format. Please use YYYY-MM-DD.");
        disengage;
    }
    year = int(parts[0]);
    month = int(parts[1]);
    day = int(parts[2]);
    try {
        dt = datetime.date(year, month, day);
        # 0=Monday, 6=Sunday
        days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"];
        print(f"Day of week: {days[dt.weekday()]}");
    } catch {
        print("Invalid date. Please check your input.");
    }
    disengage;
}

with entry:__main__ {
    root spawn DayOfWeek();
}
