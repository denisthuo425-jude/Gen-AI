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
    # Simple manual validation (not full leap year logic)
    valid = True;
    if month < 1 or month > 12 {
        valid = False;
    } elif day < 1 or day > 31 {
        valid = False;
    }
    if not valid {
        print("Invalid date. Please check your input.");
        disengage;
    }
    # Calculate day of week using Zeller's congruence
    m = month;
    y = year;
    if m < 3 {
        m = m + 12;
        y = y - 1;
    }
    K = y % 100;
    J = y // 100;
    h = (day + int((13 * (m + 1)) / 5) + K + int(K / 4) + int(J / 4) + 5 * J) % 7;
    # Zeller's: 0=Saturday, 1=Sunday, ..., 6=Friday
    days = ["Saturday", "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday"];
    print("Day of week: " + days[h]);
    disengage;
}

with entry:__main__ {
    root spawn DayOfWeek();
}
