use crate::common::*;

use just_0_4_1::summary as old;

impl Upgrade for old::Summary {
  type Output = Summary;

  fn upgrade(self) -> Self::Output {
    Summary {
      assignments: self.assignments.upgrade(),
      recipes: self.recipes.upgrade(),
    }
  }
}

impl Upgrade for old::Assignment {
  type Output = Assignment;

  fn upgrade(self) -> Self::Output {
    Assignment {
      exported: self.exported,
      expression: self.expression.upgrade(),
    }
  }
}

impl Upgrade for old::Recipe {
  type Output = Recipe;

  fn upgrade(self) -> Self::Output {
    Recipe {
      aliases: self.aliases,
      dependencies: self.dependencies,
      lines: self.lines.upgrade(),
      private: self.private,
      quiet: self.quiet,
      shebang: self.shebang,
      parameters: self.parameters.upgrade(),
    }
  }
}

impl Upgrade for old::Line {
  type Output = Line;

  fn upgrade(self) -> Self::Output {
    Line {
      fragments: self.fragments.upgrade(),
    }
  }
}

impl Upgrade for old::Fragment {
  type Output = Fragment;

  fn upgrade(self) -> Self::Output {
    match self {
      old::Fragment::Text { text } => Fragment::Text { text },
      old::Fragment::Expression { expression } => Fragment::Expression {
        expression: expression.upgrade(),
      },
    }
  }
}

impl Upgrade for old::Expression {
  type Output = Expression;

  fn upgrade(self) -> Self::Output {
    match self {
      old::Expression::Backtick { command } => Expression::Backtick { command },
      old::Expression::Call { name, arguments } => Expression::Call {
        name,
        arguments: arguments.upgrade(),
      },
      old::Expression::Concatination { lhs, rhs } => Expression::Concatination {
        lhs: Box::new(lhs.upgrade()),
        rhs: Box::new(rhs.upgrade()),
      },
      old::Expression::String { text } => Expression::String { text },
      old::Expression::Variable { name } => Expression::Variable { name },
    }
  }
}

impl Upgrade for old::Parameter {
  type Output = Parameter;

  fn upgrade(self) -> Self::Output {
    Parameter {
      variadic: self.variadic,
      name: self.name,
      default: self.default.upgrade(),
    }
  }
}
