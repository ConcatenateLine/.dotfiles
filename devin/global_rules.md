## 🏷️ Naming Conventions

| Item                 | Convention | Example                              |
| -------------------- | ---------- | ------------------------------------ |
| Folders & Files      | kebab-case | `auth-service.ts`, `user-profile/`   |
| Screens & Components | PascalCase | `LoginScreen.tsx`, `Header.tsx`      |
| Services & Hooks     | camelCase  | `authService.ts`, `useAuth.ts`       |
| Modules              | camelCase  | `user-profile` or `userProfile`      |
| Types & Interfaces   | PascalCase | `RedisKey.ts`, `CleanupReport.ts`    |
| Utilities            | camelCase  | `formatDate.ts`, `validateEmail.ts`  |
| Constants            | UPPERCASE  | `MAX_LOGIN_ATTEMPTS`, `API_BASE_URL` |
| Markdown Reports     | kebab-case | `report.md`, `cleanup-report.md`     |

## 📚 Context7

Always use context7 when I need code generation, setup or configuration steps, or
library/API documentation. This means you should automatically use the Context7 MCP tools to resolve library id and get library docs without me having to explicitly ask.
