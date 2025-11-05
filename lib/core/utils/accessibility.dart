String discountSemantics(int discountPercent) =>
    'Discounted by $discountPercent percent';

String countdownSemantics(Duration duration) =>
    duration.inMinutes <= 0
        ? 'Starting now'
        : 'Starts in ${duration.inMinutes} minutes';
