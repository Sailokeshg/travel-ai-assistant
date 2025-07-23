# Travel AI App - Modular Architecture

## Project Structure

The Travel AI App has been refactored into a clean, modular architecture that follows Flutter best practices for production-ready applications.

### Directory Structure

```
lib/
├── main.dart                          # App entry point
├── constants/
│   └── app_constants.dart            # App-wide constants and configuration
├── models/
│   └── conversation_message.dart     # Data models for conversation messages
├── services/
│   └── recommendation_service.dart   # API service layer for backend communication
├── screens/
│   └── recommendation_page.dart      # Main screen widget
└── widgets/
    ├── conversation_list.dart        # Displays conversation history
    ├── empty_state.dart             # Empty state when no messages
    ├── error_display.dart           # Error message display
    ├── loading_card.dart            # Loading indicator card
    ├── message_card.dart            # Individual message display
    └── message_input.dart           # Text input and send button
```

## Architecture Benefits

### 1. **Separation of Concerns**

- **Services**: Handle API calls and business logic
- **Models**: Define data structures and types
- **Widgets**: Reusable UI components
- **Screens**: Page-level widgets that compose other components
- **Constants**: Centralized configuration

### 2. **Reusability**

- Each widget can be tested and used independently
- Components can be easily reused across different screens
- Clear interfaces between components

### 3. **Maintainability**

- Changes to one component don't affect others
- Easy to locate and fix issues
- Clear code organization makes onboarding easier

### 4. **Scalability**

- Easy to add new features (different message types, persistence, etc.)
- Simple to extend with new screens or widgets
- Architecture supports team development

### 5. **Testability**

- Each component can be unit tested independently
- Clear separation makes mocking easier
- Reduced complexity in individual components

## Component Descriptions

### Models

- **ConversationMessage**: Represents a single message in the conversation with type safety and utility methods

### Services

- **RecommendationService**: Handles all API communication with the backend, includes error handling

### Widgets

- **MessageCard**: Displays individual messages with proper styling for user vs AI messages
- **ConversationList**: Manages the scrollable list of messages with loading states
- **MessageInput**: Handles user input with proper validation and submission
- **EmptyState**: Clean initial state when no conversation exists
- **LoadingCard**: Consistent loading indicator
- **ErrorDisplay**: Standardized error message display

### Screens

- **RecommendationPage**: Main screen that orchestrates all components and manages state

## Key Features Maintained

- ✅ Real-time conversation with AI backend
- ✅ Markdown rendering for AI responses
- ✅ Loading states and error handling
- ✅ Conversation history management
- ✅ Responsive UI with proper theming
- ✅ Link handling in AI responses
- ✅ Clear conversation functionality

## Development Guidelines

### Adding New Features

1. Create models in `models/` for new data structures
2. Add services in `services/` for new API endpoints
3. Create reusable widgets in `widgets/`
4. Compose widgets in screens for new pages

### Code Style

- Use const constructors where possible
- Follow Flutter naming conventions
- Add proper documentation for public APIs
- Include error handling in all async operations

### Testing

- Test each widget independently
- Mock services for UI tests
- Include integration tests for complete flows

This modular architecture ensures the codebase remains maintainable and scalable as the application grows.
